import 'package:flutter/material.dart';
import 'styles.dart';
import 'model/ccard.dart';
import 'model/transaction_history.dart';

class CardsPage extends StatefulWidget {
  CardsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CardsPageState createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  List<CCard> wallet = List();

  @override
  void initState() {
    super.initState();

    wallet
      ..add(CCard(
        last4Digits: "0321",
        accentImagePath: "images/card_accent1.png",
        backgroundColor: Colors.deepPurple,
        cardProviderLogoPath: "images/visa_logo.png",
        balance: "\$666.87",
      ))
      ..add(CCard(
        last4Digits: "4444",
        accentImagePath: "images/card_accent2.png",
        backgroundColor: Colors.red,
        cardProviderLogoPath: "images/visa_logo.png",
        balance: "\$4,087.68",
      ))
      ..add(CCard(
        last4Digits: "5432",
        accentImagePath: "images/card_accent3.png",
        backgroundColor: Colors.pinkAccent,
        cardProviderLogoPath: "images/visa_logo.png",
        balance: "\$332.03",
      ));
  }

  _tinyDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Container(
        width: 70,
        child: Divider(
          height: 2,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  _buildPill(String text) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.black.withAlpha(100), width: 1),
        color: Colors.black.withAlpha(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: Colors.black.withAlpha(175),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  _listTransactions(List<Transaction> t) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (_, idx) {
        return Container(
          height: 65,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      t[idx].name,
                      style: tableTitleTextStyle,
                    ),
                    Text(
                      t[idx].category,
                      style: tableSubtitleTextStyle,
                    ),
                  ],
                ),
                Spacer(),
                Text(t[idx].amount),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, idx) {
        return Divider(
          height: 1,
          color: Colors.grey[300],
        );
      },
      itemCount: t.length,
    );
  }

  _buildTransactionHistory() {
    TransactionHistory th = TransactionHistory();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Transaction History", style: h6TextStyle),
        _buildPill("yesterday"),
        _listTransactions(th.yesterday),
        _buildPill("other"),
        _listTransactions(th.other),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Center(
          child: Text(
            "Back",
            style: navItemTextStyle,
          ),
        ),
        title: Text(
          widget.title,
          style: titleTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CardSwiper(this.wallet),
            _tinyDivider(),
            _buildTransactionHistory(),
          ],
        ),
      ),
    );
  }
}

class CardSwiper extends StatefulWidget {
  final List<CCard> cards;

  const CardSwiper(this.cards);

  @override
  _CardSwiperState createState() => _CardSwiperState();
}

class _CardSwiperState extends State<CardSwiper>
    with SingleTickerProviderStateMixin {
  Animation<double> dotFadeInAnimation;
  Animation<double> dotFadeOutAnimation;
  Animation<double> balanceAnimation;

  AnimationController _controller;

  int _currentPageIndex;
  int _lastPageIndex;
  double _currentPage;

  PageController _pageController;

  VoidCallback onChanged;

  @override
  void initState() {
    super.initState();

    _currentPage = 0;
    _currentPageIndex = 0;
    _lastPageIndex = 0;

    _controller = AnimationController(
      duration: Duration(milliseconds: 160),
      vsync: this,
    );

    dotFadeInAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    dotFadeOutAnimation = Tween<double>(begin: 1, end: 0).animate(_controller);

    _controller.forward();
  }

  _buildPageDots() {
    final List<Widget> pageDots = [];
    for (int i = 0; i < widget.cards.length; i++) {
      pageDots
        ..add(
          AnimatedBuilder(
            builder: (ctx, child) {
              return Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (i == _currentPageIndex)
                      ? Colors.black
                          .withAlpha((255 * dotFadeInAnimation.value).toInt())
                      : (i == _lastPageIndex)
                          ? Colors.black.withAlpha(
                              (255 * dotFadeOutAnimation.value).toInt())
                          : Colors.transparent,
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              );
            },
            animation: _controller,
          ),
        )
        ..add(
          SizedBox(
            width: 4,
          ),
        );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pageDots,
    );
  }

  @override
  void dispose() {
    _pageController.removeListener(onChanged);
    _pageController.dispose();

    _controller.dispose();
    super.dispose();
  }

  double _getOpacityFromPageValue(double v) {
    int wholeNumber = v.round();
    double decimal = v - wholeNumber;
    
    // make sure it's a neg.
    if (decimal > 0) {
      // *= -2 because the highest decimal will ever be is 0.5
      decimal *= -2;
    } else {
      decimal *= 2;
    }

    // return whatever 1 - the offset is
    return (1 + decimal).clamp(0, 1).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    _pageController = PageController(viewportFraction: 0.7);
    onChanged = () {
      setState(() {
        _currentPage = _pageController.page;

        if (_currentPageIndex != _currentPage.round()) {
          _lastPageIndex = _currentPageIndex;
          _currentPageIndex = _currentPage.round();

          _controller.reset();
          _controller.forward();
        }
      });
    };

    _pageController.addListener(onChanged);

    return Column(
      children: <Widget>[
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, idx) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8.0,
                  top: 24,
                ),
                child: PrettyCard(widget.cards[idx]),
              );
            },
            itemCount: widget.cards.length,
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(0, -20, 0),
          child: _buildPageDots(),
        ),
        Opacity(
          opacity: _getOpacityFromPageValue(_currentPage),
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Balance", style: h2TextStyle),
              SizedBox(
                width: 4,
              ),
              Text(
                widget.cards[_currentPageIndex].balance,
                style: TextStyle(
                  color: widget.cards[_currentPageIndex].backgroundColor,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PrettyCard extends StatelessWidget {
  final CCard displayCard;

  const PrettyCard(this.displayCard);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: displayCard.backgroundColor.withAlpha(150),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
            image: DecorationImage(
              image: AssetImage(displayCard.accentImagePath),
              fit: BoxFit.cover,
            ),
            color: displayCard.backgroundColor,
          ),
        ),
        Positioned(
          top: 15,
          left: 15,
          height: 20,
          child: Image.asset(
            displayCard.cardProviderLogoPath,
            fit: BoxFit.fitHeight,
          ),
        ),
        Positioned(
          top: 15,
          right: 15,
          height: 20,
          child: Icon(
            Icons.bubble_chart,
            color: Colors.white,
          ),
        ),
        Positioned(
          bottom: 50,
          right: 20,
          left: 15,
          child: Text(
            "**** ${displayCard.last4Digits}",
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Courier',
            ),
          ),
        )
      ],
    );
  }
}
