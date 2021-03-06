#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Анализируем доп. параметры
	Если ЗначениеЗаполнено(Параметры.КодКлассификатораНаселенногоПункта) Тогда
		СтруктураПараметров = Новый Структура;
		С_АдресныйКлассификаторСервер.ПоКодуАдресногоЭлементаВСтруктуруПолучитьЕгоКомпоненты(Параметры.КодКлассификатораНаселенногоПункта, СтруктураПараметров);
		ЗаполнитьЗначенияСвойств(Параметры, СтруктураПараметров, , "Улица");
	КонецЕсли;
	
	Если ПустаяСтрока(Параметры.Регион) и Параметры.Уровень > 1 Тогда 
		//1С-Минск   
        Если Лев(Параметры.КодКлассификатораНаселенногоПункта, 1) <> "5" Тогда
            // для Минска - исключение, т.е. не изменяем
            Параметры.Уровень = 0;
            //Параметры.Регион = " ";
        КонецЕсли;     
        //Параметры.Уровень = 0;
        //Конец 1С-Минск
	КонецЕсли;

	Уровень = Параметры.Уровень;
	
	УстановитьЗаголовокФормы(Параметры.Уровень);
	
	// Переданный параметр скрытия адресов перевешивает настройки, эта же переменная отвечает за режим работы
	ИспользоватьСохраненныеНастройки = ТипЗнч(Параметры.СкрыватьНеактуальныеАдреса)<>Тип("Булево");
	
	Если ИспользоватьСохраненныеНастройки Тогда
		// Восстанавливаем значение флага "Скрывать неактуальные адреса" из настроек и даем возможность управления
		СкрыватьНеактуальныеАдреса = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("КонтактнаяИнформация.ВводАдреса", "СкрыватьНеактуальныеАдреса", Ложь);
	Иначе
		СкрыватьНеактуальныеАдреса = Параметры.СкрыватьНеактуальныеАдреса;
	КонецЕсли;
	
	// Команда переключения
	Элементы.СкрыватьНеактуальныеАдреса.Видимость = ИспользоватьСохраненныеНастройки;
	Элементы.СкрыватьНеактуальныеАдреса.Пометка = СкрыватьНеактуальныеАдреса;
	
	// Колонка неактуальной картинки
	Элементы.Актуальность.Видимость = Не ИспользоватьСохраненныеНастройки;
	
	// Колонки альтернативных названий
	УстановитьВидимостьАльтернативныхНазваний(Элементы, ВыводитьАльтернативныеНазвания);
	
	// Установим отбор по входным параметрам
	Для Каждого КлючЗначение Из ПолучитьОграниченияПоУровню(Параметры.Уровень) Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Наименование", "", ВидСравненияКомпоновкиДанных.НеРавно);
	
	// Установим текущую строку
	Поля = ПолучитьПоляПоУровню(Параметры.Уровень + 1);
	СтруктураОтбора = С_АдресныйКлассификаторСервер.ВернутьСтруктуруАдресногоКлассификатораПоАдреснымЭлементам(
		Поля.Регион, Поля.Район, Поля.Город, Поля.НаселенныйПункт, Поля.Улица
	);
	
	// Уточним по коду
	КодТекущейСтроки = Неопределено;
	Если Уровень = 1 И Параметры.Свойство("РегионКодКлассификатора") Тогда
		КодТекущейСтроки = Параметры.РегионКодКлассификатора;
		
	ИначеЕсли Уровень = 2 И Параметры.Свойство("РайонКодКлассификатора") Тогда
		КодТекущейСтроки = Параметры.РайонКодКлассификатора;
		
	ИначеЕсли Уровень = 3 И Параметры.Свойство("ГородКодКлассификатора") Тогда
		КодТекущейСтроки = Параметры.ГородКодКлассификатора;
		
	ИначеЕсли Уровень = 4 И Параметры.Свойство("НаселенныйПунктКодКлассификатора") Тогда
		КодТекущейСтроки = Параметры.НаселенныйПунктКодКлассификатора;
		
	ИначеЕсли Уровень = 5 И Параметры.Свойство("УлицаКодКлассификатора") Тогда
		КодТекущейСтроки = Параметры.УлицаКодКлассификатора;
		
	КонецЕсли;
	
	Если СтруктураОтбора.ТипАдресногоЭлемента = Параметры.Уровень Тогда
		Если КодТекущейСтроки = Неопределено Тогда
			Параметры.ТекущаяСтрока = РегистрыСведений.С_АдресныйКлассификатор.СоздатьКлючЗаписи(СтруктураОтбора)
		Иначе
			Параметры.ТекущаяСтрока = КлючЗаписиПоКодуКлассификатора(КодТекущейСтроки);
		КонецЕсли;
	КонецЕсли;
	
	// Для автосохранения настроек
	СохраняемыеВНастройкахДанныеМодифицированы = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Уровень = 0 Тогда
		// Родитель - уровень выбора неопределен, выбирать нечего
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОсуществитьВыбор();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОсуществитьВыбор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СкрыватьНеактуальныеАдреса(Команда)
	Если ИспользоватьСохраненныеНастройки Тогда
		СкрыватьНеактуальныеАдреса = Не СкрыватьНеактуальныеАдреса;
		Элементы.СкрыватьНеактуальныеАдреса.Пометка = СкрыватьНеактуальныеАдреса;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, 
			"ПризнакАктуальности", 0, ВидСравненияКомпоновкиДанных.Равно, НСтр("ru = 'Признак актуальности'"), СкрыватьНеактуальныеАдреса);
		ЭтотОбъект.ОбновитьОтображениеДанных();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьАльтернативныеНазвания(Команда)
	
	ВыводитьАльтернативныеНазвания = Не ВыводитьАльтернативныеНазвания;
	УстановитьВидимостьАльтернативныхНазваний(Элементы, ВыводитьАльтернативныеНазвания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьАльтернативныхНазваний(Знач ЭлементыФормы, ВыводитьАльтернативныеНазвания)
	
	ЭлементыФормы.СписокВыводитьАльтернативныеНазвания.Пометка = ВыводитьАльтернативныеНазвания;
	//ЭлементыФормы.Дополнительно.Видимость                      = ВыводитьАльтернативныеНазвания;
	
	// Видимость шапки в зависимости от состава колонок
	//ЭлементыФормы.Список.Шапка = ЭлементыФормы.Дополнительно.Видимость И ЭлементыФормы.ГруппаАдрес.Видимость;
КонецПроцедуры

&НаКлиенте
Процедура ОсуществитьВыбор()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
		
	ИначеЕсли ТекущиеДанные.ПризнакАктуальности<>0 Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 %2 не актуален.
			     |Продолжить?'"), 
			ТекущиеДанные.Наименование, ТекущиеДанные.Сокращение);
			
		ДополнительныеПараметры = Новый Структура("ТекущиеДанные", ТекущиеДанные);
		Оповещение = Новый ОписаниеОповещения("ОсуществитьВыборЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
		Возврат;
	КонецЕсли;
	
	ОкончаниеОсуществленияВыбора(ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ОсуществитьВыборЗавершение(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	Если РезультатВопроса<>КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОкончаниеОсуществленияВыбора(ДополнительныеПараметры.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеОсуществленияВыбора(Знач ТекущиеДанные)
	Результат = СформироватьРезультатВыбораСервер(ТекущиеДанные, СкрыватьНеактуальныеАдреса, Уровень, ИспользоватьСохраненныеНастройки);
	
#Если ВебКлиент Тогда
	ФлагЗакрытия = ЗакрыватьПриВыборе;
	ЗакрыватьПриВыборе = Ложь;
	ОповеститьОВыборе(Результат);
	ЗакрыватьПриВыборе = ФлагЗакрытия;
#Иначе
	ОповеститьОВыборе(Результат);
#КонецЕсли
	
	Если (МодальныйРежим Или ЗакрыватьПриВыборе) И Открыта() Тогда        
		Закрыть(Результат);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьПоляПоУровню(Уровень)
	
	Поля = Новый Структура;
	Поля.Вставить("Регион",          ?(Уровень <= 1, "", Параметры.Регион));
	Поля.Вставить("Район",           ?(Уровень <= 2, "", Параметры.Район));
	Поля.Вставить("Город",           ?(Уровень <= 3, "", Параметры.Город));
	Поля.Вставить("НаселенныйПункт", ?(Уровень <= 4, "", Параметры.НаселенныйПункт));
	Поля.Вставить("Улица",           ?(Уровень <= 5, "", Параметры.Улица));
	
	Возврат Поля;
	
КонецФункции

&НаСервере
Функция ПолучитьОграниченияПоУровню(УровеньОбъекта, Знач КодКлассификатораНаселенногоПункта = Неопределено)
	
	//1с-минск
	
	//Если КодКлассификатораНаселенногоПункта = Неопределено Тогда
	//	КодКлассификатораНаселенногоПункта = Параметры.КодКлассификатораНаселенногоПункта;
	//КонецЕсли;
	//
	//Если ЗначениеЗаполнено(КодКлассификатораНаселенногоПункта) Тогда
	//	// Выбор улицы
	//	Ограничения = ИзмеренияНаселенногоПункта(КодКлассификатораНаселенногоПункта);
	//	Ограничения.Вставить("ТипАдресногоЭлемента", 5);
	//Иначе
	//	// Опираемся на глобально доступные параметры - наименования частей адреса и уровень
	//	Поля = ПолучитьПоляПоУровню(УровеньОбъекта);
	//	Ограничения = АдресныйКлассификатор_Локализация.ВернутьСтруктуруОграниченийПоРодителю(
	//		Поля.Регион, Поля.Район, Поля.Город, Поля.НаселенныйПункт, Поля.Улица, 0, УровеньОбъекта
	//	);
	//	
	//	// Уточняем коды по параметрам
	//	ТекущийКод = Неопределено;
	//	Если Ограничения.Свойство("КодАдресногоОбъектаВКоде") И Параметры.Свойство("РегионКодКлассификатора", ТекущийКод) И ЗначениеЗаполнено(ТекущийКод) Тогда
	//		Ограничения.КодАдресногоОбъектаВКоде = ИзмеренияНаселенногоПункта(ТекущийКод).КодАдресногоОбъектаВКоде;
	//	КонецЕсли;
	//	ТекущийКод = Неопределено;
	//	Если Ограничения.Свойство("КодРайонаВКоде") И Параметры.Свойство("РайонКодКлассификатора", ТекущийКод) И ЗначениеЗаполнено(ТекущийКод) Тогда
	//		Ограничения.КодРайонаВКоде = ИзмеренияНаселенногоПункта(ТекущийКод).КодРайонаВКоде;
	//	КонецЕсли;
	//	ТекущийКод = Неопределено;
	//	Если Ограничения.Свойство("КодГородаВКоде") И Параметры.Свойство("ГородКодКлассификатора", ТекущийКод) И ЗначениеЗаполнено(ТекущийКод) Тогда
	//		Ограничения.КодГородаВКоде = ИзмеренияНаселенногоПункта(ТекущийКод).КодГородаВКоде;
	//	КонецЕсли;
	//	ТекущийКод = Неопределено;
	//	Если Ограничения.Свойство("КодНаселенногоПунктаВКоде") И Параметры.Свойство("НаселенныйПунктКодКлассификатора", ТекущийКод) И ТекущийКод <> Неопределено Тогда
	//		Ограничения.КодНаселенногоПунктаВКоде = ИзмеренияНаселенногоПункта(ТекущийКод).КодНаселенногоПунктаВКоде;
	//	КонецЕсли;
	//	
	//КонецЕсли;

	//Если СкрыватьНеактуальныеАдреса Тогда
	//	Ограничения.Вставить("ПризнакАктуальности", 0);
	//КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.КодКлассификатораНаселенногоПункта) Тогда
		Ограничения = Новый Структура("ТипАдресногоЭлемента", 5);
		
		// Дом, Признак актуальности, Улица
		ПолныйКод  = Цел(Параметры.КодКлассификатораНаселенногоПункта/(10000 * 100 * 10000));
		
		// Населенный пункт
		Ограничения.Вставить("КодНаселенногоПунктаВКоде", ПолныйКод % 1000);
		ПолныйКод = Цел(ПолныйКод/1000);
		
		// Город
		Ограничения.Вставить("КодГородаВКоде", ПолныйКод % 1000);
		ПолныйКод = Цел(ПолныйКод/1000);
		
		// Район
		Ограничения.Вставить("КодРайонаВКоде", ПолныйКод % 1000);
		ПолныйКод = Цел(ПолныйКод/1000);
		
		// Регион
		Ограничения.Вставить("КодАдресногоОбъектаВКоде", ПолныйКод);
	Иначе
		Поля = ПолучитьПоляПоУровню(Уровень);
		Ограничения = С_АдресныйКлассификаторСервер.ВернутьСтруктуруОграниченийПоРодителю(
			Поля.Регион, Поля.Район, Поля.Город, Поля.НаселенныйПункт, Поля.Улица, 0, Уровень);
	КонецЕсли;

	Если СкрыватьНеактуальныеАдреса Тогда
		Ограничения.Вставить("ПризнакАктуальности", 0);
	КонецЕсли;
	
	
	Возврат Ограничения;    
	
	//1с-минск

КонецФункции

&НаСервере
Процедура УстановитьЗаголовокФормы(Уровень)
	Если Уровень = 1 Тогда
		Заголовок = НСтр("ru = 'Выберите регион'");
	ИначеЕсли Уровень = 2 Тогда
		Заголовок = НСтр("ru = 'Выберите район'");
	ИначеЕсли Уровень = 3 Тогда
		Заголовок = НСтр("ru = 'Выберите город'");
	ИначеЕсли Уровень = 4 Тогда
		Заголовок = НСтр("ru = 'Выберите населенный пункт'");
	ИначеЕсли Уровень = 5 Тогда
		Заголовок = НСтр("ru = 'Выберите улицу'");
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция СформироватьРезультатВыбораСервер(ТекущиеДанные, СкрыватьНеактуальныеАдреса, Уровень, ИспользоватьСохраненныеНастройки)
	
	// Данные текущей строки списка, переданной через параметры    
	Результат = Новый Структура("Наименование, Сокращение, ПризнакАктуальности, Код");
	ЗаполнитьЗначенияСвойств(Результат, ТекущиеДанные);
	Результат.Вставить("КодРегиона", ТекущиеДанные.КодАдресногоОбъектаВКоде);
	
	// Реквизиты формы, переданные через параметры
	Результат.Вставить("СкрыватьНеактуальныеАдреса", СкрыватьНеактуальныеАдреса);
	Результат.Вставить("Уровень", Уровень);
	
	// Вычисляемые
	//1С-Минск
    Если Уровень < 4 Тогда
        Результат.Вставить("Представление", СокрЛП( 
        ?(ПустаяСтрока(Результат.Наименование), "", СокрЛП(Результат.Наименование) + " " + СокрЛП(Результат.Сокращение))
        ));
    Иначе	
        Результат.Вставить("Представление", СокрЛП( 
        ?(ПустаяСтрока(Результат.Наименование), "", СокрЛП(Результат.Сокращение) + " " + СокрЛП(Результат.Наименование))
        ));
    КонецЕсли;     
    //Конец 1C-Минск
	
	// Вычисляемые
	Результат.Вставить("Представление", СокрЛП( 
		?(ПустаяСтрока(Результат.Наименование), "", СокрЛП(Результат.Наименование) + " " + СокрЛП(Результат.Сокращение))));
	Результат.Вставить("ПолноеНаименование", Результат.Представление);
	
	// Структура адреса
	СтруктураАдреса = С_АдресныйКлассификаторСервер.СтруктураАдреса(Результат.Код);
	
	Если ИспользоватьСохраненныеНастройки Тогда
		СтруктураАдреса.Вставить("СкрыватьНеактуальныеАдреса", 
			ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("КонтактнаяИнформация.ВводАдреса", "СкрыватьНеактуальныеАдреса", Ложь));
	КонецЕсли;
	
	СтруктураПолей = ИсправитьПоля(СтруктураАдреса, Уровень);
	
	СтруктураАдреса.Вставить("СтруктураОшибок",      СтруктураПолей.СтруктураОшибок);
	СтруктураАдреса.Вставить("СтруктураЗагруженных", ЗагруженныеПоляПоРегиону(СтруктураАдреса));
	СтруктураАдреса.Вставить("МожноЗагружатьРегион", ЗагружатьРегион(СтруктураАдреса.Регион));
	
	Результат.Вставить("СтруктураАдреса", СтруктураАдреса);
	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Функция ИсправитьПоля(СтруктураАдреса, Уровень)
	
	// Получаем поля из структуры адреса
	Индекс = СтруктураАдреса.Индекс;
	Регион = СтруктураАдреса.Регион;
	Район = СтруктураАдреса.Район;
	Город = СтруктураАдреса.Город;
	НаселенныйПункт = СтруктураАдреса.НаселенныйПункт;
	Улица = СтруктураАдреса.Улица;
	Дом = СтруктураАдреса.Дом;
	Корпус = СтруктураАдреса.Корпус;
	Квартира = СтруктураАдреса.Квартира;
	
	Если Не С_АдресныйКлассификаторСервер.АдресныйЭлементЗагружен(Регион) Тогда
		СтруктураПолей = Новый Структура("СтруктураОшибок,СтруктураАдреса", Новый Структура, СтруктураАдреса);
		Возврат СтруктураПолей;
	КонецЕсли;
	
	СтруктураПроверки = С_АдресныйКлассификаторСервер.ПроверитьСоответствиеАдресаКЛАДРу(
		"", Регион, Район, Город, НаселенныйПункт, Улица, Дом, Корпус);
	
	// Очищаем не подходящие поля
	Если СтруктураПроверки.ЕстьОшибки Тогда
		С_АдресныйКлассификаторСервер.ОчиститьПотомковПоУровнюАдресногоЭлемента(
			Регион, Район, Город, НаселенныйПункт, Улица, Дом, Корпус, Квартира, Уровень);
	КонецЕсли;
	
	// Заполняем или исправляем промежуточные поля
	Если Уровень > 2 И (ПустаяСтрока(Район) Или СтруктураПроверки.СтруктураОшибок.Свойство("Район")) Тогда
		Район = СокрЛП(СтруктураПроверки.Район.Наименование + " " + СтруктураПроверки.Район.Сокращение);	
	КонецЕсли;
	
	Если Уровень > 3 И (ПустаяСтрока(Город) Или СтруктураПроверки.СтруктураОшибок.Свойство("Город")) Тогда
		Город = СокрЛП(СтруктураПроверки.Город.Наименование + " " + СтруктураПроверки.Город.Сокращение);	
	КонецЕсли;
	
	Если Уровень > 4 И (ПустаяСтрока(НаселенныйПункт) Или СтруктураПроверки.СтруктураОшибок.Свойство("НаселенныйПункт")) Тогда
		НаселенныйПункт = СокрЛП(СтруктураПроверки.НаселенныйПункт.Наименование + " " 
		                 + СтруктураПроверки.НаселенныйПункт.Сокращение);
	КонецЕсли;
	
	// Исправляем индекс
	НовыйИндекс = С_АдресныйКлассификаторСервер.ИндексАдреса(Регион, 
		Район, Город, НаселенныйПункт, Улица, Дом, Корпус);
	
	Если Не ПустаяСтрока(НовыйИндекс) Тогда
		Индекс = НовыйИндекс;
	КонецЕсли;
	
	// Обновляем структуру адреса
	СтруктураАдреса.Индекс = Индекс;
	СтруктураАдреса.Регион = Регион;
	СтруктураАдреса.Район = Район;
	СтруктураАдреса.Город = Город;
	СтруктураАдреса.НаселенныйПункт = НаселенныйПункт;
	СтруктураАдреса.Улица = Улица;
	СтруктураАдреса.Дом = Дом;
	СтруктураАдреса.Корпус = Корпус;
	СтруктураАдреса.Квартира = Квартира;
	
	// Проверяем еще раз и возвращаем структуру ошибок
	СтруктураПроверки = С_АдресныйКлассификаторСервер.ПроверитьСоответствиеАдресаКЛАДРу(
		"", Регион, Район, Город, НаселенныйПункт, Улица, Дом, Корпус);
	
	СтруктураПроверки.Вставить("СтруктураАдреса", СтруктураАдреса);
	Возврат СтруктураПроверки;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗагружатьРегион(Регион)
	
	// Загрузить регион могут только администраторы или пользователи с правом добавления/изменения базовой НСИ
	Если Не Пользователи.РолиДоступны("ДобавлениеИзменениеОбщейБазовойНСИ") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Разбиваем регион на наименование и сокращение
	АдресноеСокращение = "";
	НаименованиеРегиона = С_АдресныйКлассификаторСервер.ИмяИАдресноеСокращение(Регион, АдресноеСокращение);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	С_АдресныйКлассификатор.Код КАК Код
	|ИЗ
	|	РегистрСведений.С_АдресныйКлассификатор КАК С_АдресныйКлассификатор
	|ГДЕ
	|	С_АдресныйКлассификатор.ТипАдресногоЭлемента = 1
	|	И С_АдресныйКлассификатор.Наименование = &НаименованиеРегиона";
	Запрос.УстановитьПараметр("НаименованиеРегиона", НаименованиеРегиона);
	
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат Ложь; // Загружаются только регионы, которые есть в списке регионов.
	Иначе
		РегионЗагружен = С_АдресныйКлассификаторСервер.АдресныйЭлементЗагружен(Регион);
		Возврат Не РегионЗагружен; // Загружаем регион, если он не загружен.
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗагруженныеПоляПоРегиону(СтруктураАдреса)
	
	Если С_АдресныйКлассификаторСервер.АдресныйЭлементЗагружен(СтруктураАдреса.Регион) Тогда
		СтруктураЗагруженных = С_АдресныйКлассификаторСервер.СтруктураЗагруженныхЭлементовАдреса(
		СтруктураАдреса.Регион, СтруктураАдреса.Район, СтруктураАдреса.Город, СтруктураАдреса.НаселенныйПункт, СтруктураАдреса.Улица);
		Возврат СтруктураЗагруженных;
		
	Иначе
		Возврат Новый Структура("Регион", Ложь);
		
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция КлючЗаписиПоКодуКлассификатора(Знач Код)
	
	СтрокаИзмерений = "ТипАдресногоЭлемента, КодАдресногоОбъектаВКоде, КодРайонаВКоде, КодГородаВКоде, КодНаселенногоПунктаВКоде, КодУлицыВКоде, Код";
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1 
		|	" + СтрокаИзмерений + "
		|ИЗ
		|	РегистрСведений.С_АдресныйКлассификатор
		|ГДЕ
		|	Код = &Код
		|");
		
	Запрос.УстановитьПараметр("Код", Код);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗначенияИзмерений = Новый Структура(СтрокаИзмерений);
		ЗаполнитьЗначенияСвойств(ЗначенияИзмерений, Выборка);
		Возврат РегистрыСведений.С_АдресныйКлассификатор.СоздатьКлючЗаписи(ЗначенияИзмерений);
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементыУсловногоОформления = Список.УсловноеОформление.Элементы;
	
	ЭлементыУсловногоОформления.Очистить();
	
	Элемент = ЭлементыУсловногоОформления.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Дополнительно");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Дополнительно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(128,128,128));
	
КонецПроцедуры

#КонецОбласти

