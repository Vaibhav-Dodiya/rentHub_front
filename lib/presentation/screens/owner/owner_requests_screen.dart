import 'package:flutter/material.dart';
import 'package:loginsignup/core/services/api_service.dart';
import 'package:loginsignup/data/local/user_storage.dart';
import 'package:intl/intl.dart';

class OwnerRequestsScreen extends StatefulWidget {
  const OwnerRequestsScreen({super.key});

  @override
  State<OwnerRequestsScreen> createState() => _OwnerRequestsScreenState();
}

class _OwnerRequestsScreenState extends State<OwnerRequestsScreen> {
  List<Map<String, dynamic>> requests = [];
  bool isLoading = true;
  String selectedFilter = 'ALL'; // ALL, PENDING, ACCEPTED, REJECTED

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() => isLoading = true);
    try {
      final userId = await UserStorage.getUserId();
      if (userId != null) {
        final fetchedRequests = await ApiService.getOwnerRequests(userId);
        setState(() {
          requests = fetchedRequests;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading requests: $e')));
      }
    }
  }

  List<Map<String, dynamic>> get filteredRequests {
    if (selectedFilter == 'ALL') return requests;
    return requests.where((req) => req['status'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRequests,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('ALL'),
                  const SizedBox(width: 8),
                  _buildFilterChip('PENDING'),
                  const SizedBox(width: 8),
                  _buildFilterChip('ACCEPTED'),
                  const SizedBox(width: 8),
                  _buildFilterChip('REJECTED'),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          // Requests list
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredRequests.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          selectedFilter == 'ALL'
                              ? 'No requests yet'
                              : 'No $selectedFilter requests',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadRequests,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: filteredRequests.length,
                      itemBuilder: (context, index) {
                        return _buildRequestCard(filteredRequests[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = selectedFilter == filter;
    final count = filter == 'ALL'
        ? requests.length
        : requests.where((req) => req['status'] == filter).length;

    return FilterChip(
      label: Text('$filter ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          selectedFilter = filter;
        });
      },
      selectedColor: Colors.orange[200],
      checkmarkColor: Colors.orange[900],
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    final status = request['status'] ?? 'PENDING';
    final requestDate = request['requestDate'] != null
        ? DateTime.parse(request['requestDate'])
        : DateTime.now();
    final formattedDate = DateFormat(
      'MMM dd, yyyy • HH:mm',
    ).format(requestDate);

    Color statusColor;
    IconData statusIcon;
    switch (status) {
      case 'ACCEPTED':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'REJECTED':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    request['propertyTitle'] ?? 'Unknown Property',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Category badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                request['propertyCategory'] ?? 'Property',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.blue[900],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Divider(height: 24),
            // Requester info
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  'From: ',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                Expanded(
                  child: Text(
                    request['requesterName'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    request['requesterEmail'] ?? 'No email',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Message
            if (request['message'] != null &&
                request['message'].toString().isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  request['message'],
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            const SizedBox(height: 8),
            // Date
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            // Action buttons (only for pending requests)
            if (status == 'PENDING') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _updateRequestStatus(request['id'], 'REJECTED'),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _updateRequestStatus(request['id'], 'ACCEPTED'),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Accept'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _updateRequestStatus(String requestId, String status) async {
    try {
      final success = await ApiService.updateRequestStatus(requestId, status);
      if (success) {
        await _loadRequests();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Request ${status.toLowerCase()} successfully'),
              backgroundColor: status == 'ACCEPTED' ? Colors.green : Colors.red,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update request'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
