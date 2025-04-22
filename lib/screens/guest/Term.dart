import 'package:flutter/material.dart';

class TermScreen extends StatefulWidget {
  final Function(int) onChangedStep;
  const TermScreen({Key? key, required this.onChangedStep}) : super(key: key);

  @override
  State<TermScreen> createState() => _TermScreenState();
}

class _TermScreenState extends State<TermScreen> {
  ScrollController _scrollController = ScrollController();
  bool _termsReaded = false;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() => _termsReaded = true);
      }
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          elevation: 0,
          title: Text('Terms & Conditions'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => {widget.onChangedStep(2)},
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'En utilisant cette application de chat pour développeurs, vous acceptez les présentes conditions d\'utilisation. '
                        'Si vous n\'acceptez pas ces termes, veuillez ne pas installer ni utiliser l\'application. '
                        'Nous nous réservons le droit de modifier ces conditions à tout moment, et votre utilisation continue du service '
                        'après ces modifications vaut acceptation de la nouvelle version.\n\n'
                        'L\'accès à cette application est strictement réservé aux développeurs professionnels ou amateurs dans le cadre '
                        'd\'échanges techniques. Vous certifiez que vous disposez des compétences ou de la formation appropriée pour '
                        'participer aux discussions techniques sur cette plateforme. Toute utilisation à des fins non professionnelles ou '
                        'non liées au développement logiciel est strictement interdite.\n\n'
                        '- Le spam\n'
                        '- Le harcèlement\n'
                        '- Les propos discriminatoires\n'
                        '- Le partage de code malveillant\n'
                        '- Toute discussion illégale concernant le piratage\n'
                        '- Les failles de sécurité non divulguées publiquement\n'
                        '- Les méthodes de contournement de licences logicielles\n\n'
                        'Nous nous réservons le droit de supprimer tout contenu inapproprié et de bannir immédiatement tout utilisateur '
                        'contrevenant sans avertissement préalable.\n\n'
                        'Lorsque vous partagez du code ou des solutions techniques, vous garantissez que vous en possédez les droits ou que '
                        'leur diffusion est autorisée (licence open source, etc.). Le plagiat ou la réutilisation non créditée de code '
                        'provenant d\'autres utilisateurs est strictement interdit.\n\n'
                        'Notez que les échanges sur ce chat ne constituent pas une relation client-prestataire - les conseils fournis par la '
                        'communauté sont à titre informatif et nous déclinons toute responsabilité quant à leur mise en œuvre.',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  backgroundColor:
                      _termsReaded
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: !_termsReaded ? null : () => widget.onChangedStep(2),
                child: Text(
                  'accept & continue'.toUpperCase(),
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
