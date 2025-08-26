import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedFilterIndex = 0;

  final List<String> _filterOptions = ['All', 'Users', 'Moments', 'Videos', 'Hashtags'];

  // Dummy search results
  final List<Map<String, dynamic>> _searchResults = [
    {
      'type': 'user',
      'name': 'dishi_007',
      'avatar': 'assets/images/girl_img1.png',
      'followers': '2.5K',
      'isFollowing': false,
    },
    {
      'type': 'moment',
      'user': 'dishi_007',
      'avatar': 'assets/images/girl_img1.png',
      'image': 'assets/images/girl_img2.png',
      'caption': 'I\'m Beachamtic and I\'m happiest my toes in Sand.',
      'likes': '156',
      'time': '2h ago',
    },
    {'type': 'hashtag', 'tag': '#snapyourlife', 'posts': '12.5K'},
    {
      'type': 'video',
      'user': 'dishi_007',
      'avatar': 'assets/images/girl_img1.png',
      'thumbnail': 'assets/images/background_reel.jpeg',
      'duration': '0:15',
      'views': '1.2K',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(text: 'Search', fontSize: 18, fontWeight: FontWeight.w600),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black),
            onPressed: () {
              // Show filter options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomContainer(
              conColor: Colors.grey[100] ?? Colors.grey.shade100,
              borderRadius: BorderRadius.circular(25),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search for users, moments, videos...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    ),
                ],
              ),
            ),
          ),

          // Filter Chips
          if (_searchQuery.isNotEmpty)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filterOptions.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedFilterIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      },
                      child: CustomContainer(
                        conColor: isSelected ? const Color(0xffFFD964) : (Colors.grey[200] ?? Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(20),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: CustomText(
                          text: _filterOptions[index],
                          color: isSelected ? Colors.black : (Colors.grey[700] ?? Colors.grey.shade700),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Search Results
          if (_searchQuery.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  return _buildSearchResult(result, index);
                },
              ),
            )
          else
            // Empty State
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 64, color: Colors.grey[400] ?? Colors.grey.shade400),
                    const SizedBox(height: 16),
                    CustomText(
                      text: 'Search for something amazing',
                      fontSize: 18,
                      color: Colors.grey[600] ?? Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      text: 'Find users, moments, videos, and hashtags',
                      fontSize: 14,
                      color: Colors.grey[500] ?? Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResult(Map<String, dynamic> result, int index) {
    switch (result['type']) {
      case 'user':
        return _buildUserResult(result, index);
      case 'moment':
        return _buildMomentResult(result, index);
      case 'hashtag':
        return _buildHashtagResult(result, index);
      case 'video':
        return _buildVideoResult(result, index);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildUserResult(Map<String, dynamic> result, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(radius: 25, backgroundImage: AssetImage(result['avatar'])),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: result['name'], fontSize: 16, fontWeight: FontWeight.w600),
                CustomText(
                  text: '${result['followers']} followers',
                  fontSize: 14,
                  color: Colors.grey[600] ?? Colors.grey.shade600,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchResults[index]['isFollowing'] = !_searchResults[index]['isFollowing'];
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: result['isFollowing'] ? Colors.grey[300] : const Color(0xffFFD964),
              foregroundColor: result['isFollowing'] ? Colors.grey[700] : Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(result['isFollowing'] ? 'Following' : 'Follow'),
          ),
        ],
      ),
    );
  }

  Widget _buildMomentResult(Map<String, dynamic> result, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomContainer(
        conColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2))],
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 16, backgroundImage: AssetImage(result['avatar'])),
                  const SizedBox(width: 8),
                  CustomText(text: result['user'], fontWeight: FontWeight.w600),
                  const Spacer(),
                  CustomText(
                    text: result['time'],
                    fontSize: 12,
                    color: Colors.grey[600] ?? Colors.grey.shade600,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomText(text: result['caption']),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(result['image'], height: 120, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.favorite, color: Colors.red[400] ?? Colors.red.shade400, size: 16),
                  const SizedBox(width: 4),
                  CustomText(
                    text: result['likes'],
                    fontSize: 12,
                    color: Colors.grey[600] ?? Colors.grey.shade600,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHashtagResult(Map<String, dynamic> result, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xffFFD964),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tag, color: Colors.black, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: result['tag'], fontSize: 16, fontWeight: FontWeight.w600),
                CustomText(
                  text: '${result['posts']} posts',
                  fontSize: 14,
                  color: Colors.grey[600] ?? Colors.grey.shade600,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoResult(Map<String, dynamic> result, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(result['thumbnail'], height: 60, width: 80, fit: BoxFit.cover),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CustomText(text: result['duration'], fontSize: 10, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: result['user'], fontWeight: FontWeight.w600),
                CustomText(
                  text: '${result['views']} views',
                  fontSize: 12,
                  color: Colors.grey[600] ?? Colors.grey.shade600,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.play_circle_outline, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
