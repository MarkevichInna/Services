
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Авторизация = С_АдресныйКлассификаторСервер.ПараметрыАутентификацииНаСайте();
	Если Авторизация.Заполнено Тогда
		Логин  = Авторизация.Логин;
		Пароль = Авторизация.Пароль;
	КонецЕсли;
	
	ЗапомнитьПароль = Не ПустаяСтрока(Пароль);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПерейтиКРегистрацииНаСайтеНажатие(Элемент)
	
	ПерейтиПоНавигационнойСсылке("http://users.v8.1c.ru/");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Кнопка "Продолжить", выполнение выбора.
//
// Результат выбора:
//     Структура, Неопределено - Если пользователь отказался от ввода пароля, то Неопределено. Иначе - структура с полями:
//        * Логин  - Строка - Логин на сайте
//        * Пароль - Строка - Введенный пароль
//
&НаКлиенте
Процедура СохранитьДанныеАутентификацииИПродолжить()
	
	Результат = Новый Структура("Логин, Пароль", Логин, Пароль);
	Если ЗапомнитьПароль Тогда
		СохранитьДанныеАутентификации(Результат);
	КонецЕсли;
	
	ОповеститьОВыборе(Результат);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура СохранитьДанныеАутентификации(Знач Аутентификация)
	
	С_АдресныйКлассификаторСервер.ПараметрыАутентификацииНаСайте(Аутентификация);
	
КонецПроцедуры

#КонецОбласти
