# Кототиндер Про

Приложение для свайпа котиков с онбордингом и локальной авторизацией. Сделано как доработка первого ДЗ под второе.

## Что сделано

**Из первого ДЗ (всё на месте):**
- Главный экран со случайным котиком и счётчиком лайков
- Свайп влево/вправо и кнопки лайк/дизлайк, по тапу на котика — экран с деталями породы
- Таб «Породы» со списком и поиском, по тапу — детали породы (описание и характеристики)
- Обработка ошибок (диалог с сообщением и «Повторить»)
- Кастомная иконка и тема
- API thecatapi.com (http), картинки через CachedNetworkImage

**Добавлено во втором ДЗ:**
- **Онбординг** — при первом запуске показывается PageView с тремя шагами (Свайпы, Породы, Избранное), на каждом — текст и анимированная иконка (AnimatedScale). Кнопки «Далее» и «Начать». После «Начать» онбординг больше не показывается (флаг в SharedPreferences).
- **Регистрация и вход** — экраны логина и регистрации с полями email и пароль, валидация (email по RegExp, пароль не короче 6 символов). Пароль и статус входа хранятся в **flutter_secure_storage** (keychain). После успешного входа попадаешь на главный экран с табами; при следующем запуске приложения снова сразу главный экран, без повторного логина.
- **Архитектура** — код разнесён по слоям: `lib/data` (сервисы API, авторизации, онбординга, лайков, аналитики), `lib/domain` (сущности, строки AppStrings, валидаторы), `lib/presentation` (экраны, виджеты, контроллеры). Зависимости собираются в `AppDependencies`, контроллеры через Provider.
- **Аналитика AppMetrica** — сервис `AnalyticsService` в `lib/data/services/analytics_service.dart`. Логируются события: успех/ошибка входа и регистрации, завершение онбординга. Ключ передаётся через `--dart-define=METRICA_KEY=...`; без ключа аналитика не активируется.
- **Строки и валидация** — все тексты в `AppStrings`, валидация email/пароля в `AppValidators`, форма входа/регистрации общая (виджет `AuthForm`).
- **Тесты** — unit-тесты на валидаторы и на `AuthController` (успех/ошибка логина и регистрации, logout, checkAuthStatus), widget-тесты на форму входа (валидация полей, успешный логин, неверный пароль). Всего 30 тестов, `flutter test` проходит.
- **CI/CD** — GitHub Actions (`.github/workflows/flutter_ci.yml`): при каждом push и pull_request в `main` запускаются `flutter pub get`, `flutter analyze --fatal-infos`, `flutter test` с заглушками ключей.

## Демо и установка

- **Видеодемонстрация приложения:** [Смотреть на Яндекс.Диске](https://disk.yandex.ru/i/v-Uya_IhpXKqmA)
- **APK:** https://github.com/Tengir/flutter-catinder-pro/releases/tag/v1.0.0

## Скриншоты AppMetrica

<img width="2366" height="972" alt="image" src="https://github.com/user-attachments/assets/0a479749-b748-4a24-a8d6-7df20821392f" />
<img width="2818" height="1411" alt="image" src="https://github.com/user-attachments/assets/f6998ae8-dbf6-40d1-8634-76021d93367e" />


## Как запустить

1. Поставить Flutter (проверял на 3.9).
2. Получить ключ на [thecatapi.com](https://thecatapi.com) и ключ приложения в [AppMetrica](https://appmetrica.yandex.ru/).
3. В корне проекта:
   ```bash
   flutter pub get
   flutter run --dart-define=CAT_API_KEY=твой_ключ --dart-define=METRICA_KEY=ключ_аппметрики
   ```
   Без ключа API приложение запустится с жёсткими лимитами; без METRICA_KEY аналитика не будет отправляться.

## Как собрать APK

```bash
flutter build apk --release --dart-define=CAT_API_KEY=твой_ключ --dart-define=METRICA_KEY=ключ_аппметрики
```

Готовый файл: `build/app/outputs/flutter-apk/app-release.apk`.

## Тесты

```bash
flutter test --dart-define=CAT_API_KEY=test --dart-define=METRICA_KEY=test
```

Должно пройти 30 тестов (validators, AuthController, AuthForm). В CI те же ключи-заглушки передаются автоматически.

---

Если что-то не запускается или падают тесты — напиши, разберёмся.
