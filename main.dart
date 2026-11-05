import 'package:flutter/material.dart';

void main() {
  runApp(const NewsReaderApp());
}

class NewsReaderApp extends StatelessWidget {
  const NewsReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Reader',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const NewsHomePage(),
    );
  }
}

class Article {
  final String title;
  final String source;
  final String date;
  final String category;
  final String description;

  Article({
    required this.title,
    required this.source,
    required this.date,
    required this.category,
    required this.description,
  });
}

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Technology',
    'Sports',
    'Business',
    'Health',
    'Science',
  ];

  final List<Article> articles = [
    Article(
      title: 'Artificial Intelligence is Changing the World',
      source: 'Tech News',
      date: '04 Nov 2026',
      category: 'Technology',
      description:
          'Artificial Intelligence is transforming education, healthcare, '
          'business and many other industries.',
    ),
    Article(
      title: 'India Wins an Important Cricket Match',
      source: 'Sports Daily',
      date: '04 Nov 2026',
      category: 'Sports',
      description:
          'The Indian cricket team delivers an impressive performance '
          'in an exciting match.',
    ),
    Article(
      title: 'Global Business Markets Show Growth',
      source: 'Business Times',
      date: '03 Nov 2026',
      category: 'Business',
      description:
          'Business markets are experiencing changes due to technology '
          'and international trade.',
    ),
    Article(
      title: 'New Discoveries in Medical Science',
      source: 'Health News',
      date: '02 Nov 2026',
      category: 'Health',
      description:
          'Researchers continue to explore new developments in '
          'medical science and healthcare.',
    ),
    Article(
      title: 'Scientists Explore Space Technology',
      source: 'Science Daily',
      date: '01 Nov 2026',
      category: 'Science',
      description:
          'Scientists are developing new technologies to understand '
          'space and the universe.',
    ),
  ];

  final Set<int> bookmarks = {};
  final Map<int, String> notes = {};

  List<Article> get filteredArticles {
    if (selectedCategory == 'All') {
      return articles;
    }

    return articles
        .where((article) =>
            article.category == selectedCategory)
        .toList();
  }

  void openArticle(int index) {
    final article = articles.indexOf(filteredArticles[index]);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailPage(
          article: articles[article],
          isBookmarked: bookmarks.contains(article),
          savedNote: notes[article] ?? '',
          onBookmark: () {
            setState(() {
              if (bookmarks.contains(article)) {
                bookmarks.remove(article);
              } else {
                bookmarks.add(article);
              }
            });
          },
          onSaveNote: (note) {
            setState(() {
              notes[article] = note;
            });
          },
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News Reader',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmarks),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookmarkPage(
                    articles: articles,
                    bookmarks: bookmarks,
                    notes: notes,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Latest News',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredArticles.length,
              itemBuilder: (context, index) {
                final article = filteredArticles[index];
                final originalIndex = articles.indexOf(article);

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(14),
                    leading: const CircleAvatar(
                      child: Icon(Icons.newspaper),
                    ),
                    title: Text(
                      article.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${article.source} • ${article.date}\n'
                        '${article.category}',
                      ),
                    ),
                    trailing: Icon(
                      bookmarks.contains(originalIndex)
                          ? Icons.bookmark
                          : Icons.arrow_forward_ios,
                    ),
                    onTap: () => openArticle(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleDetailPage extends StatefulWidget {
  final Article article;
  final bool isBookmarked;
  final String savedNote;
  final VoidCallback onBookmark;
  final Function(String) onSaveNote;

  const ArticleDetailPage({
    super.key,
    required this.article,
    required this.isBookmarked,
    required this.savedNote,
    required this.onBookmark,
    required this.onSaveNote,
  });

  @override
  State<ArticleDetailPage> createState() =>
      _ArticleDetailPageState();
}

class _ArticleDetailPageState
    extends State<ArticleDetailPage> {
  late TextEditingController noteController;
  late bool bookmarked;

  @override
  void initState() {
    super.initState();
    bookmarked = widget.isBookmarked;
    noteController =
        TextEditingController(text: widget.savedNote);
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Article Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.article.category.toUpperCase(),
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.article.title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${widget.article.source} • ${widget.article.date}',
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 30),
            const Icon(
              Icons.newspaper,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Article Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.article.description,
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                widget.onBookmark();
                setState(() {
                  bookmarked = !bookmarked;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      bookmarked
                          ? 'Article Bookmarked!'
                          : 'Bookmark Removed',
                    ),
                  ),
                );
              },
              icon: Icon(
                bookmarked
                    ? Icons.bookmark
                    : Icons.bookmark_border,
              ),
              label: Text(
                bookmarked
                    ? 'Bookmarked'
                    : 'Add Bookmark',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Personal Notes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: noteController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Write your personal notes...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                widget.onSaveNote(noteController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Note Saved Successfully!'),
                  ),
                );
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}

class BookmarkPage extends StatelessWidget {
  final List<Article> articles;
  final Set<int> bookmarks;
  final Map<int, String> notes;

  const BookmarkPage({
    super.key,
    required this.articles,
    required this.bookmarks,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final saved = bookmarks.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Bookmarks')),
      body: saved.isEmpty
          ? const Center(child: Text('No Bookmarks Yet'))
          : ListView.builder(
              itemCount: saved.length,
              itemBuilder: (context, index) {
                final articleIndex = saved[index];
                final article = articles[articleIndex];

                return Card(
                  child: ListTile(
                    title: Text(article.title),
                    subtitle: Text(
                      '${article.source} • ${article.date}\n'
                      'Note: ${notes[articleIndex] ?? "No notes"}',
                    ),
                    isThreeLine: true,
                    leading: const Icon(
                      Icons.bookmark,
                      color: Colors.blue,
                    ),
                  ),
                );
              },
            ),
    );
  }
}