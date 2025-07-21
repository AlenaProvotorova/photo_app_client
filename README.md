flutter run -d chrome --web-port=3001

Запуск flutter приложения через симулятор

запуск сервера
=> сначала нужно запустить базу, данные для базы хранятся в .env
=> npm run start

Структура каталогов:

|-> core - общие компоненты, общие классы приложения, константы
|
|-> data - все что связано с получением данных из источников и их преобразованием для чистых моделей приложения
|----> dto
|----> mappers
|----> repositories
|
|-> domain - чистые модели данных, которые используются в приложении
|----> models
|
|-> presentation - страницы и окна

как происходит работа с данными:
JSON => fromJson() => DTO(Data Transfer Object) => toDomain() => model
?
DTO - промежуточная ступень, которая достигается при десериализации json, чтобы преобразовать в модель

?
команда для генерации файлов '.../.g.dart'
flutter packages pub run build_runner build --delete-conflicting-outputs

Пример/последовательность шагов на примере создания авторизации

1. в папке domain/auth/repositories в файле auth.dart создается абстрактный класс
2. Далее в папке data/auth/repositories создаем файл auth.dart. Здесь реализуем абстрактный класс, который был создан на 1 шаге. Через быстрое исправление добавляем override signUp() метод

[промежуточный шаг] - на этом этапе установили библиотеку dartz, чтобы подтянуть из него тип <Either>

3. Потом в папке data/auth/sources создаем файл auth_api_service.dart. Внутри создаем абстрактный класс AuthApiService и явное определение signUp() метод. В этом же файле создаем класс AuthApiServiceImplementation, который реализует абстрактный класс AuthApiService и реализует signUp() метод.

[промежуточный шаг] - на этом этапе установили библиотеку dio, чтобы использовать ее для работы с API, установили библиотеку get_it, чтобы использовать ее для работы с service_locator, создали в папке lib файл service_locator.dart.  
[промежуточный шаг] - идем в файл main.dart и в методе main() вызываем WidgetsFlutterBinding.ensureInitialized() и метод setupServiceLocator()

4. Идем в папку data/auth/sources в файл auth_api_service.dart. Добавляем блок try/catch, внутри которого у нас запрос к серверу.

[промежуточный шаг] - в папке core/constants создаем файл api_url.dart. В нем создаем класс ApiUrl, в котором создаем константу baseURL и signUp.

5. в папке data/auth/models создаем файл signup_req_params.dart. Там создаем класс SignUpReqParams, в котором создаем поля email и password.

6. Далее идем domain/auth/repositories в файл auth.dart. Там в абстрактном классе AuthRepository создаем метод signUp(SignUpReqParams params).

7. Во всех файлах, где используется signUp(), используем метод signUp(SignUpReqParams params) из абстрактного класса AuthRepository.

8. Идем в файл data/auth/models/signup_req_params.dart. Там через быстрое редактирование выбираем Generate Data class. Из всего сгенерированного кода оставляем только метод toMap()

9. В файле data/auth/sources/auth_api_service.dart возвращаем из try Right(response.data);

10. В файле data/auth/repositories/auth.dart в методе signUp() используем метод signUp(SignUpReqParams params) из абстрактного класса AuthRepository.

[промежуточный шаг] - в папке core/usecase создаем файл usecase.dart. Там создаем абстрактный класс Usecase<Type, Params> и явное определение call(Params params) метод.

11. В файле domain/auth/usecases/signup.dart используем метод call(SignUpReqParams? params) из абстрактного класса Usecase<Type, Params>.

12. В UI добавляем контроллеры для ввода email и password. и обработчик нажатия(отправка запроса с параметрами на сервер)

====singin

13. В папке domain/auth/repositories домавляем в репозиторий метод signIn(SignInReqParams params)
14. В папке domain/auth/usecases создаем файл signin.dart. Там создаем класс SignInUsecase, который реализует абстрактный класс Usecase<Type, Params> и реализует метод call(SignInReqParams? params)
15. В папке data/auth/repositories создаем файл auth.dart. Там создаем метод signIn(SignInReqParams params)
16. В папке data/auth/sources в файле auth_api_service.dart добавляем метод signIn(SignInReqParams params)
17. В папке data/auth/models создаем файл signin_req_params.dart. Там создаем класс SignInReqParams, в котором создаем поля email и password.
18. В ui добавляем контроллеры для ввода email и password. и обработчик нажатия(отправка запроса с параметрами на сервер)

текстовая ТЕМА
APPBAR - headlineMedium
