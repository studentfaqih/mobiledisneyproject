import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'
    as custom_carousel; // Alias added here
import '../services/api_service.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _trendingMovies = [];
  List<Map<String, dynamic>> _actionMovies = [];
  List<Map<String, dynamic>> _animatedMovies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    try {
      final trending = await _apiService.searchMovies('marvel');
      final action = await _apiService.searchMovies('action');
      final animated = await _apiService.searchMovies('pixar');

      setState(() {
        _trendingMovies =
            List<Map<String, dynamic>>.from(trending['Search'] ?? []);
        _actionMovies = List<Map<String, dynamic>>.from(action['Search'] ?? []);
        _animatedMovies =
            List<Map<String, dynamic>>.from(animated['Search'] ?? []);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading movies: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFeaturedSlider(),
                      _buildSection('Trending', _trendingMovies),
                      _buildSection('Action Movies', _actionMovies),
                      _buildSection('Animated Movies', _animatedMovies),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: const Color(0xFF1A1D29),
      title: const Text(
        'Movieify',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildFeaturedSlider() {
    return custom_carousel.CarouselSlider(
      // Using alias here
      options: custom_carousel.CarouselOptions(
        // Using alias here
        height: 200,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
      ),
      items: _trendingMovies.take(5).map((movie) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(movie['Poster'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(movie: movie);
            },
          ),
        ),
      ],
    );
  }
}
