import 'package:flutter/material.dart';
import '../localizations/app_localizations.dart';
import '../widgets/background_image.dart';

class AboutScreen extends StatelessWidget {
  static const String routeName = '/about';

  List<Widget> _arabicContent() {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Image.asset('assets/images/logo.png'),
      ),
      Text(
        'تريت-من هو مشروع تخرج مجموعة من الطلاب المقيدين'
        ' بكلية الهندسة جامعة عين شمس. دفعة 2021.\n\n'
        'تريت-من هو خدمة تهدف إلى تسهيل عملية إيجاد العيادات بمختلف التخصصات '
        'والخدمات الطبية الأخري بجميع أنحاء مصر. وايضا يعطي معلومات عن أقرب'
        ' المستشفيات في حالة الطوارئ.\n\n'
        'الفكرة خلف الاسم (تريت-من) هي أن المستخدم يمكنه إيجاد العلاج المناسب'
        ' له في دقيقة واحدة فقط :)\n\n'
        'تم تطوير هذا التطبيق بواسطة:\n'
        'خالد محمد رفعت',
        textAlign: TextAlign.justify,
      ),
      Text('khalid.refaat98@gmail.com', textAlign: TextAlign.end),
      Text('أحمد خالد سيد'),
      Text('ahmedkhaled11119999@gmail.com\n', textAlign: TextAlign.end),
      Text(
        'تحت إشراف:\n'
        'أ. د. أحمد حسن\n'
        'م. سارة عبده\n'
        'رقم الإصدار: 1.0.0',
      ),
    ];
  }

  List<Widget> _englishContent() {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Image.asset('assets/images/logo.png'),
      ),
      Text(
        'Treat-min is the graduation project of a group of students of '
        'Faculty of Engineering, Ain Shams University. Class of 2021\n\n'
        'Treat-min is a service that aims to facilitate the process of '
        'finding clinics of different specialities and other medical services '
        'all over Egypt. It also provides information about nearest hospitals '
        'in case of emergency.\n\n'
        'The idea behind the name (Treat-min) is that users can find their '
        'appropriate treatment in just one minute :)\n\n'
        'This application is developed by:\n'
        'Khalid Muhammad Refaat',
        textAlign: TextAlign.justify,
      ),
      Text('khalid.refaat98@gmail.com', textAlign: TextAlign.end),
      Text('Ahmed Khalid Sayed'),
      Text('ahmedkhaled11119999@gmail.com\n', textAlign: TextAlign.end),
      Text(
        'Under the supervision of:\n'
        'Prof. Dr. Ahmed Hassan\n'
        'Eng. Sarah Abdu\n\n'
        'Version Number: 1.0.0',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    setAppLocalization(context);

    return Scaffold(
      appBar: AppBar(title: Text(t('about_us'))),
      body: BackgroundImage(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowGlow();
            return;
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: langCode == 'ar' ? _arabicContent() : _englishContent(),
          ),
        ),
      ),
    );
  }
}