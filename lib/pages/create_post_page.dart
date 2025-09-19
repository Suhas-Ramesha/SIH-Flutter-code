import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/post.dart';
import '../providers/posts_provider.dart';
import '../providers/auth_provider.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});
  
  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _areaController = TextEditingController();
  
  String _selectedCategory = '';
  String _selectedSeverity = 'Medium';
  double _severityValue = 1.0; // 0 = Low, 1 = Medium, 2 = High
  List<File> _selectedImages = [];
  double _latitude = 12.9716; // Default Bangalore coordinates
  double _longitude = 77.5946;
  bool _isLoading = false;
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _areaController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final postsNotifier = ref.read(postsProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submitPost,
            child: const Text('Post'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Category Selection
              _buildCategorySection(),
              
              const SizedBox(height: 24),
              
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Brief description of the issue',
                  border: OutlineInputBorder(),
                ),
                maxLength: AppConstants.maxPostTitleLength,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  if (value.length < 10) {
                    return 'Title must be at least 10 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Detailed description of the issue',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                maxLength: AppConstants.maxPostDescriptionLength,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 20) {
                    return 'Description must be at least 20 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Severity Section
              _buildSeveritySection(),
              
              const SizedBox(height: 24),
              
              // Location Section
              _buildLocationSection(),
              
              const SizedBox(height: 24),
              
              // Images Section
              _buildImagesSection(),
              
              const SizedBox(height: 32),
              
              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitPost,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Submit Report',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.categories.map((category) {
            final isSelected = _selectedCategory == category;
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category : '';
                });
              },
            );
          }).toList(),
        ),
        if (_selectedCategory.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Please select a category',
              style: TextStyle(color: AppTheme.errorColor, fontSize: 12),
            ),
          ),
      ],
    );
  }
  
  Widget _buildSeveritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Severity: $_selectedSeverity',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Slider(
          value: _severityValue,
          min: 0,
          max: 2,
          divisions: 2,
          label: _selectedSeverity,
          onChanged: (value) {
            setState(() {
              _severityValue = value;
              _selectedSeverity = AppConstants.severityLevels[value.round()];
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: AppConstants.severityLevels.map((severity) {
            final index = AppConstants.severityLevels.indexOf(severity);
            final isSelected = _selectedSeverity == severity;
            return Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.getSeverityColor(severity) : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  severity,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? AppTheme.getSeverityColor(severity) : Colors.grey[600],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Area Field
        TextFormField(
          controller: _areaController,
          decoration: const InputDecoration(
            labelText: 'Area',
            hintText: 'e.g., Koramangala 4th Block',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the area';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        // Location Info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.my_location, color: AppTheme.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Current Location',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _getCurrentLocation,
                    child: const Text('Update'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Lat: ${_latitude.toStringAsFixed(4)}, Lng: ${_longitude.toStringAsFixed(4)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Images (${_selectedImages.length}/${AppConstants.maxImagesPerPost})',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Image Grid
        if (_selectedImages.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _selectedImages.length + (_selectedImages.length < AppConstants.maxImagesPerPost ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _selectedImages.length) {
                return GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderColor, style: BorderStyle.solid),
                    ),
                    child: const Center(
                      child: Icon(Icons.add_photo_alternate, size: 32, color: AppTheme.textSecondaryColor),
                    ),
                  ),
                );
              }
              
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.errorColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        else
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderColor, style: BorderStyle.solid),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, size: 48, color: AppTheme.textSecondaryColor),
                    SizedBox(height: 8),
                    Text(
                      'Add Images',
                      style: TextStyle(color: AppTheme.textSecondaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        
        const SizedBox(height: 8),
        Text(
          'Add photos to help describe the issue. You can add up to ${AppConstants.maxImagesPerPost} images.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }
  
  Future<void> _pickImage() async {
    if (_selectedImages.length >= AppConstants.maxImagesPerPost) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only add up to ${AppConstants.maxImagesPerPost} images')),
      );
      return;
    }
    
    final ImagePicker picker = ImagePicker();
    
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromSource(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromSource(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      
      if (image != null) {
        final file = File(image.path);
        
        // Check file size
        final fileSize = await file.length();
        if (fileSize > AppConstants.maxImageSize) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image size too large. Please choose a smaller image.')),
          );
          return;
        }
        
        setState(() {
          _selectedImages.add(file);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }
  
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }
  
  Future<void> _getCurrentLocation() async {
    // TODO: Implement real location service
    // For now, use mock location
    setState(() {
      _latitude = 12.9716 + (DateTime.now().millisecondsSinceEpoch % 1000) / 100000;
      _longitude = 77.5946 + (DateTime.now().millisecondsSinceEpoch % 1000) / 100000;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location updated (mock)')),
    );
  }
  
  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // TODO: Upload images to server
      final imageUrls = <String>[];
      for (final image in _selectedImages) {
        // Mock image upload
        imageUrls.add('assets/images/mock_${DateTime.now().millisecondsSinceEpoch}.jpg');
      }
      
      final request = CreatePostRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        severity: _selectedSeverity,
        latitude: _latitude,
        longitude: _longitude,
        area: _areaController.text.trim(),
        images: imageUrls,
      );
      
      final postsNotifier = ref.read(postsProvider.notifier);
      final newPost = await postsNotifier.createPost(request);
      
      if (newPost != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create post')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
