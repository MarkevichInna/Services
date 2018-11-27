// Флаг подтверждения, используется при закрытии
&НаКлиенте
Перем ПодтверждениеЗакрытияФормы;

// Хранилище передаваемых файлов
&НаКлиенте
Перем ПомещенныеФайлы;

// Параметры загрузки для передачи между клиентскими вызовами
&НаКлиенте
Перем ПараметрыФоновойОчисткиКлассификатора;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыДлительнойОперации = Новый Структура("ИнтервалОжидания, Завершено, АдресРезультата, Идентификатор, Ошибка", 5);
	
	// Получаем уже загруженные регионы
	ТаблицаРегионов = РегистрыСведений.С_АдресныйКлассификатор.СведенияОЗагрузкеСубъектовРФ();
	ТаблицаРегионов.Колонки.Добавить("Очищать", Новый ОписаниеТипов("Булево"));
	
	Для Каждого Регион Из ТаблицаРегионов Цикл
		Регион.Представление = Формат(Регион.КодСубъектаРФ, "ЧЦ=2; ЧН=; ЧВН=; ЧГ=") + ", " + Регион.Представление;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ТаблицаРегионов, "СубъектыРФ");
	
	// Автосохранение настроек
	СохраняемыеВНастройкахДанныеМодифицированы = Истина;
	
	С_УправлениеФормамиВызовСервера.ПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьИнтерфейсПоКоличествуОчищаемых();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	// Проверяем клиентскую переменную
	Если ПодтверждениеЗакрытияФормы<>Истина Тогда
		Оповещение = Новый ОписаниеОповещения("ЗакрытиеФормыЗавершение", ЭтотОбъект);
		Отказ = Истина;
		
		Текст = НСтр("ru = 'Прервать очистку адресного классификатора?'");
		ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ПараметрыДлительнойОперации.Идентификатор <> Неопределено Тогда
		//ОтменитьФоновоеЗадание(ПараметрыДлительнойОперации.Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СубъектыРФВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если Поле = Элементы.СубъектыРФПредставление Тогда
		ТекущиеДанные = СубъектыРФ.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ТекущиеДанные <> Неопределено Тогда
			ТекущиеДанные.Очищать = Не ТекущиеДанные.Очищать;
			ОбновитьИнтерфейсПоКоличествуОчищаемых();
		КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СубъектыРФОчищатьПриИзменении(Элемент)
	
	ОбновитьИнтерфейсПоКоличествуОчищаемых();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьПометкиСпискаРегионов(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьПометкиСпискаРегионов(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	ОчиститьКлассификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьОчистку(Команда)
	
	ПодтверждениеЗакрытияФормы = Неопределено;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Завершение диалога закрытия формы
&НаКлиенте
Процедура ЗакрытиеФормыЗавершение(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПодтверждениеЗакрытияФормы = Истина;
		Закрыть();
	Иначе 
		ПодтверждениеЗакрытияФормы = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРазрешениеОчистки(Знач КоличествоОчищаемых = Неопределено)
	
	Если КоличествоОчищаемых = Неопределено Тогда
		КоличествоОчищаемых = СубъектыРФ.НайтиСтроки( Новый Структура("Очищать", Истина) ).Количество();
	КонецЕсли;
	
	Элементы.Очистить.Доступность = КоличествоОчищаемых > 0
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	Поля = Элемент.Поля.Элементы;
	Поля.Добавить().Поле = Новый ПолеКомпоновкиДанных("СубъектыРФКодСубъектаРФ");
	Поля.Добавить().Поле = Новый ПолеКомпоновкиДанных("СубъектыРФПредставление");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СубъектыРФ.Загружено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноСерый);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкиСпискаРегионов(Знач Пометка)
	
	// Устанавливаем пометки только для видимых строк
	ЭлементТаблицы = Элементы.СубъектыРФ;
	Для Каждого СтрокаРегиона Из СубъектыРФ Цикл
		Если ЭлементТаблицы.ДанныеСтроки( СтрокаРегиона.ПолучитьИдентификатор() ) <> Неопределено Тогда
			СтрокаРегиона.Очищать = Пометка;
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьИнтерфейсПоКоличествуОчищаемых();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПоКоличествуОчищаемых()
	
	// Страница выбора
	ВыбраноРегионовДляОчистки = СубъектыРФ.НайтиСтроки( Новый Структура("Очищать", Истина) ).Количество();
	
	// Страница загрузки
	ТекстОписанияОчистки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Очищаются данные выбранных регионов (%1)'"), ВыбраноРегионовДляОчистки
	);
	
	УстановитьРазрешениеОчистки(ВыбраноРегионовДляОчистки);
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьКлассификатор()
	
	ОчиститьСообщения();
	
	// Переключаем режим - страницу
	Элементы.ШагиОчистки.ТекущаяСтраница = Элементы.ОжиданиеОчистки;
	ТекстСостоянияОчистки = НСтр("ru = 'Очистка адресного классификатора ...'");
	
	Элементы.ПрерватьОчистку.Доступность = Ложь;
	
	ПараметрыФоновойОчисткиКлассификатора = Новый Структура;
	ПараметрыФоновойОчисткиКлассификатора.Вставить("КодыРегионов", КодыРегионовДляОчистки() );
	
	ИспользуемыйКлассификатор = С_АдресныйКлассификаторКлиентСервер.ИспользуемыйАдресныйКлассификатор();
	Если ИспользуемыйКлассификатор <> "КЛАДР" Тогда
		Элементы.ШагиОчистки.ТекущаяСтраница = Элементы.ВыборРегионовЗагрузки;
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не обрабатываемый тип адресного классификатора ""%1""'"), ИспользуемыйКлассификатор);
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОчиститьКлассификаторКЛАДР", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьКлассификаторКЛАДР()
	
	КодыРегионов = ПараметрыФоновойОчисткиКлассификатора.КодыРегионов;
	ПараметрыФоновойОчисткиКлассификатора= Неопределено;
	
	ЗапуститьФоновуюОчисткуНаСервере(КодыРегионов);
	ПодключитьОбработчикОжидания("Подключаемый_ОжиданиеДлительнойОперации", 0.1, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗапуститьФоновуюОчисткуНаСервере(Знач КодыРегионов)
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(КодыРегионов);
	
	ПараметрыДлительнойОперации.Идентификатор   = Неопределено;
	ПараметрыДлительнойОперации.Завершено       = Истина;
	ПараметрыДлительнойОперации.АдресРезультата = Неопределено;
	ПараметрыДлительнойОперации.Ошибка          = Неопределено;
	
	Попытка
	С_АдресныйКлассификаторСервер.ФоновоеЗаданиеОчисткиКлассификатораАдресов(ПараметрыМетода,"С_АдресныйКлассификатор.ФоновоеЗаданиеОчисткиКлассификатораАдресов");	
	Исключение
		ПараметрыДлительнойОперации.Ошибка = ПодробноеПредставлениеОшибки( ИнформацияОбОшибке() );
		Возврат;
		
	КонецПопытки;
	
	// Запущенное 
	Элементы.ПрерватьОчистку.Доступность = Истина;
КонецПроцедуры

&НаСервере
Функция СостояниеФоновогоЗадания()
	Результат = Новый Структура("Прогресс, Завершено, Ошибка");
	
	Результат.Ошибка = "";
	Если ПараметрыДлительнойОперации.Идентификатор = Неопределено Тогда
		Результат.Завершено = Истина;
		Результат.Прогресс  = Неопределено;
		Результат.Ошибка    = ПараметрыДлительнойОперации.Ошибка;
	Иначе
	КонецЕсли;
	
	Возврат Результат;
КонецФункции


&НаКлиенте
Процедура Подключаемый_ОжиданиеДлительнойОперации()
	
	// Обновим статус
	Состояние = СостояниеФоновогоЗадания();
	Если Не ПустаяСтрока(Состояние.Ошибка) Тогда
		// Завершено с ошибкой, сообщим и вернемся на первую страницу
		Элементы.ШагиОчистки.ТекущаяСтраница = Элементы.ВыборРегионовЗагрузки;
		Сообщить(Состояние.Ошибка);
		Возврат;
		
	ИначеЕсли Состояние.Завершено Тогда
		Элементы.ШагиОчистки.ТекущаяСтраница = Элементы.УспешноеЗавершение;
		ТекстОписанияОчистки = НСтр("ru = 'Адресный классификатор успешно очищен.'");
		
		Оповестить("ОчищенАдресныйКлассификатор", , ЭтотОбъект);
		
		Элементы.Закрыть.КнопкаПоУмолчанию = Истина;
		ТекущийЭлемент = Элементы.Закрыть;
		ПодтверждениеЗакрытияФормы = Истина;
		Возврат;
		
	КонецЕсли;
	
	// Процесс продолжается
	Если ТипЗнч(Состояние.Прогресс) = Тип("Структура") Тогда
		ТекстСостоянияОчистки = Состояние.Прогресс.Текст;
	КонецЕсли;
	ПодключитьОбработчикОжидания("Подключаемый_ОжиданиеДлительнойОперации", ПараметрыДлительнойОперации.ИнтервалОжидания, Истина);
	
КонецПроцедуры

&НаКлиенте
Функция КодыРегионовДляОчистки()
	Результат = Новый Массив;
	
	Для Каждого Регион Из СубъектыРФ.НайтиСтроки( Новый Структура("Очищать", Истина) ) Цикл
		Результат.Добавить(Регион.КодСубъектаРФ);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

#КонецОбласти
