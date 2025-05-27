import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/markdown_block.dart';
import 'package:minima_notes/core/theme/theme.dart';
import 'package:minima_notes/core/widgets/minima_drawer.dart';

class MarkdownTutorialView extends StatefulWidget {
  const MarkdownTutorialView({super.key});

  @override
  State<MarkdownTutorialView> createState() => _MarkdownTutorialViewState();
}

class _MarkdownTutorialViewState extends State<MarkdownTutorialView> {
  bool isViewingRaw = false;
  bool showScrollToTopButton = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
      final shouldShow = _scrollController.offset > 100;
      if (shouldShow != showScrollToTopButton) {
        setState(() {
          showScrollToTopButton = shouldShow;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MinimaDrawer(index: 1),
      appBar: AppBar(
        backgroundColor: AppTheme.grey10,
        title: const Text(
          'Markdown Basic Syntax',
          style: TextStyle(color: AppTheme.white),
        ),
        foregroundColor: AppTheme.white,
        actions: [
          IconButton(
            onPressed: _handleToggleView,
            icon: Icon(
              isViewingRaw ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppTheme.white,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.black),
                      ),
                      height: 30,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Element',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.black),
                      ),
                      height: 30,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Text / Result',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 200,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Heading'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isViewingRaw
                                        ? const SelectableText('# Heading\n## Heading\n### Heading')
                                        : const MarkdownBlock(data: '# Heading\n## Heading\n### Heading'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 60,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Bold'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isViewingRaw
                                        ? const SelectableText('**bold text**')
                                        : const MarkdownBlock(data: '**bold text**'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 60,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Italic'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isViewingRaw
                                        ? const SelectableText('*italicized text*')
                                        : const MarkdownBlock(data: '*italicized text*'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 70,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Blockquote'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isViewingRaw
                                        ? const SelectableText('> blockquote')
                                        : const Expanded(child: MarkdownBlock(data: '> blockquote')),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 150,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Ordered List'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isViewingRaw
                                        ? const SelectableText('1. First item\n2. Second item\n3. Third item')
                                        : const MarkdownBlock(
                                          data: '1. First item\n2. Second item\n3. Third item',
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 150,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Unordered List'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isViewingRaw
                                        ? const SelectableText('- First item\n- Second item\n- Third item')
                                        : const MarkdownBlock(
                                          data: '- First item\n- Second item\n- Third item',
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 60,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Code'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isViewingRaw
                                        ? const SelectableText('`code`')
                                        : const MarkdownBlock(
                                          data: '`code`',
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 60,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Horizontal Rule'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isViewingRaw
                                        ? const SelectableText('---')
                                        : const Expanded(
                                          child: MarkdownBlock(
                                            data: '---',
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 60,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Link'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isViewingRaw
                                        ? const Flexible(child: SelectableText('[title](https://www.example.com)'))
                                        : const MarkdownBlock(
                                          data: '[title](https://www.example.com)',
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 70,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Images'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isViewingRaw
                                        ? const Flexible(
                                          child: SelectableText('There is currently no support for adding images :('),
                                        )
                                        : const Flexible(
                                          child: MarkdownBlock(
                                            data: 'There is currently no support for adding images :(',
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 180,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Fenced Code Block'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 180,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isViewingRaw
                                        ? const Flexible(
                                          child: SelectableText(
                                            '```\n{\n "firstName": "John",\n "lastName": "Smith",\n "age": 25\n}\n```',
                                          ),
                                        )
                                        : const Expanded(
                                          child: MarkdownBlock(
                                            data:
                                                '```\n{\n "firstName": "John",\n "lastName": "Smith",\n "age": 25\n}\n```',
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 150,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Task List'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isViewingRaw
                                        ? const Flexible(
                                          child: SelectableText(
                                            '- [x] Write the press release\n- [ ] Update the website\n- [ ] Contact the media',
                                          ),
                                        )
                                        : const Expanded(
                                          child: MarkdownBlock(
                                            data:
                                                '- [x] Write the press release\n- [ ] Update the website\n- [ ] Contact the media',
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 150,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Strikethrough'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isViewingRaw
                                        ? const Flexible(
                                          child: SelectableText(
                                            '~~Java is awesome!~~',
                                          ),
                                        )
                                        : const Expanded(
                                          child: MarkdownBlock(
                                            data: '~~Java is awesome!~~',
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 150,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Table'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: isViewingRaw ? MainAxisAlignment.start : MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isViewingRaw
                                        ? const Flexible(
                                          child: SelectableText('''| Syntax | Description |
| ----------- | ----------- |
| Header | Title |
| Paragraph | Text |'''),
                                        )
                                        : const Expanded(
                                          child: MarkdownBlock(
                                            data: '''| Syntax | Description |
| ----------- | ----------- |
| Header | Title |
| Paragraph | Text |''',
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 150,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Footnote'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.black),
                              ),
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isViewingRaw
                                        ? const Flexible(
                                          child: SelectableText(
                                            '''Here's a sentence with a footnote. [^1]

[^1]: This is the footnote.''',
                                          ),
                                        )
                                        : const Expanded(
                                          child: MarkdownBlock(
                                            data: '''Here's a sentence with a footnote. [^1]

[^1]: This is the footnote.''',
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            MarkdownBlock(
                              data:
                                  'This Markdown content was ported from the site: [markdownguide.org](https://www.markdownguide.org/cheat-sheet/)',
                            ),
                            MarkdownBlock(
                              data:
                                  'Sadly, not all features listed in the site are supported by the Flutter library used to build this app, the ones listed here are tested and guaranteed to work, thanks for your patience, have a nice day!',
                            ),
                            SizedBox(
                              height: 64,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (showScrollToTopButton)
            Positioned(
              bottom: 16,
              right: 16,
              child: Material(
                color: AppTheme.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: AppTheme.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: InkWell(
                  splashColor: AppTheme.grey40,
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: _hanldeBackToTop,
                  child: const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(
                      Icons.arrow_upward,
                      color: AppTheme.black,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  _handleToggleView() {
    setState(() {
      isViewingRaw = !isViewingRaw;
    });
  }

  _hanldeBackToTop() {
    _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 500), curve: Curves.bounceIn);
  }
}
