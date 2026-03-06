/// Централизованные строки приложения (Domain Layer).
/// Все пользовательские и системные тексты заданы здесь.
class AppStrings {
  AppStrings._();

  // --- App ---
  static const String appTitle = 'Кототиндер';

  // --- Auth ---
  static const String authLogin = 'Вход';
  static const String authSignUp = 'Регистрация';
  static const String authEmail = 'Email';
  static const String authPassword = 'Пароль';
  static const String authButtonLogin = 'Войти';
  static const String authButtonSignUp = 'Зарегистрироваться';
  static const String authSwitchToSignUp = 'Нет аккаунта? Зарегистрироваться';
  static const String authSwitchToLogin = 'Уже есть аккаунт? Войти';

  // --- Validation ---
  static const String validationEmailEmpty = 'Введите email';
  static const String validationEmailInvalid = 'Неверный формат email';
  static const String validationPasswordEmpty = 'Введите пароль';
  static const String validationPasswordTooShort =
      'Пароль должен быть не короче 6 символов';

  // --- Auth errors (AuthService / UI) ---
  static const String authErrorUserNotFound =
      'Пользователь не найден. Сначала зарегистрируйтесь.';
  static const String authErrorWrongCredentials = 'Неверный email или пароль.';

  // --- Onboarding ---
  static const String onboardingTitleSwipes = 'Свайпы';
  static const String onboardingDescSwipes =
      'Свайпай котиков влево и вправо,\nставь лайки любимцам.';
  static const String onboardingTitleBreeds = 'Породы';
  static const String onboardingDescBreeds =
      'Смотри детали породы,\nчитай описание и характеристики.';
  static const String onboardingTitleFavorites = 'Избранное';
  static const String onboardingDescFavorites =
      'Собирай любимых котиков\nи возвращайся к ним позже.';
  static const String onboardingButtonNext = 'Далее';
  static const String onboardingButtonStart = 'Начать';

  // --- Home / Tabs ---
  static const String tabTinder = 'Тиндер';
  static const String tabBreeds = 'Породы';

  // --- Tinder ---
  static const String tinderLikesCount = 'Лайков: ';
  static const String tinderDislike = 'Дизлайк';
  static const String tinderLike = 'Лайк';
  static const String tinderNoCat = 'Пока нет котика. Обновите, пожалуйста.';
  static const String tinderTryAgain = 'Попробовать снова';
  static const String tinderTestError = 'Проверить ошибку';

  // --- Breeds ---
  static const String breedsSearchHint = 'Поиск породы';
  static const String breedsRetry = 'Повторить';

  // --- Details (labels) ---
  static const String detailCountry = 'Страна';
  static const String detailTemperament = 'Темперамент';
  static const String detailLife = 'Жизнь';
  static const String detailLifeYears = 'лет';
  static const String detailEnergy = 'Энергия';
  static const String detailAffection = 'Ласковость';
  static const String detailIntelligence = 'Интеллект';
  static const String detailMore = 'Подробнее: ';

  // --- Errors (API / Network) ---
  static const String errorDialogTitle = 'Что-то пошло не так';
  static const String errorDialogClose = 'Закрыть';
  static const String errorDialogRetry = 'Повторить';

  static const String errorTest = 'Это тестовая ошибка. Попробуйте снова.';
  static const String errorNoCat = 'Не нашли котика, попробуйте ещё раз.';
  static const String errorInvalidPayload = 'Ответ сервера не похож на котика.';
  static const String errorCatNoBreed =
      'Пришёл кот без описания. Обновите и попробуйте снова.';
  static const String errorServer = 'Сервер ответил ошибкой. Попробуйте позже.';
  static const String errorTimeout = 'Превышено время ожидания ответа.';
  static const String errorNoNetwork = 'Нет подключения к интернету.';
  static const String errorClient = 'Не удалось связаться с сервером.';
  static const String errorUnexpectedData = 'Сервер вернул неожиданные данные.';
  static const String errorParse = 'Не удалось разобрать данные от сервера.';

  // --- Breed entity defaults (API fallbacks) ---
  static const String breedUnknownOrigin = 'Неизвестно';
  static const String breedNoDescription = 'Нет описания';
  static const String breedNoTemperament = 'Не указано';
  static const String breedNoLifeSpan = '—';

  // --- Debug / main ---
  static const String debugApiKeyEmpty =
      'CAT_API_KEY is empty. Requests will work with a limited quota.';

  // --- Analytics (AppMetrica) ---
  static const String analyticsEventLoginSuccess = 'login_success';
  static const String analyticsEventLoginError = 'login_error';
  static const String analyticsEventRegistrationSuccess = 'registration_success';
  static const String analyticsEventRegistrationError = 'registration_error';
  static const String analyticsEventOnboardingFinished = 'onboarding_finished';
  static const String analyticsParamSuccess = 'success';
  static const String analyticsParamError = 'error';
}
