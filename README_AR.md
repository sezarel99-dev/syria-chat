# SYRIA CHAT — حزمة المرحلة الأولى

تم تجهيز أساس Flutter وربط إعداد Firebase المخصص للمشروع.

## ما تمت إضافته
- وضع `google-services.json` في `android/app/google-services.json`.
- بوابة دخول تعتمد حالة Firebase Authentication.
- إنشاء حساب بالبريد وكلمة المرور وتسجيل الدخول.
- فرض إكمال الملف الشخصي قبل دخول التطبيق: الاسم الظاهر واسم مستخدم فريد، مع نبذة وبلد ومدينة اختيارية.
- حفظ الملف في `users/{uid}` وحجز اسم المستخدم في `usernames/{username}` عبر Firestore transaction.
- فحص صلاحية المدير من Firebase Custom Claim باسم `role=super_admin` فقط.
- شاشة أولية للصفحة الرئيسية ولوحة المدير.
- قواعد Firestore أولية في `firestore.rules`.

## بيانات الربط
- Firebase Project ID: `syria-chat-66206`
- Android package: `com.syriachat.sezar`
- Firebase App ID: `1:1085885935466:android:34d8ce45f75f8c02bd3f13`

## تشغيل المشروع من الهاتف باستخدام محرر/منصة Flutter سحابية
1. أنشئ مشروع Flutter جديداً باسم `syria_chat` مع Android.
2. اجعل Android applicationId هو `com.syriachat.sezar`.
3. انسخ مجلد `lib` وملف `pubspec.yaml` ومجلد `assets` وملف `firestore.rules` إلى المشروع.
4. انسخ `google-services.json` الموجود هنا إلى `android/app/google-services.json` في مشروع Flutter الذي أنشأته.
5. فعّل Email/Password من Firebase Authentication وأنشئ Firestore Database.
6. الصق قواعد `firestore.rules` في تبويب Rules ثم انشرها.
7. شغّل `flutter pub get` ثم ابنِ نسخة Android.

## تفعيل المدير الرئيسي بأمان
اسم `sezar` وحده لا يمنح صلاحيات إدارية. بعد إنشاء حساب سيزر، يجب ربط UID الصحيح ومنحه Custom Claim من بيئة موثوقة (Firebase Admin SDK / Cloud Functions أو بيئة إدارية آمنة). لا تضع مفتاح Service Account داخل التطبيق ولا تمنح الصلاحية من العميل. بعد ضبط claim بالقيمة `role: super_admin` سجّل الخروج ثم الدخول مجدداً.

## ملاحظات المرحلة الحالية
هذه مرحلة تأسيسية وليست تطبيق الدردشة النهائي بعد. الغرف والرسائل والمكالمات وإدارة المشرفين الفعلية ونظام VIP الكامل وربط صور الملفات تحتاج مراحل تطوير واختبار لاحقة. واجهة رمز البريد الرقمي غير مفعّلة؛ لا تستخدم رمزاً وهمياً.
