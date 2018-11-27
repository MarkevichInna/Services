
Процедура ЗагрузкаФайла() Экспорт 

	Попытка
	
		МассивСообщений = Новый Массив;
		
		Профиль = новый ИнтернетПочтовыйПрофиль;
		Профиль.АдресСервераPOP3 = "mail.1c-minsk.by";
		Профиль.АдресСервераSMTP = "mail.1c-minsk.by";
		Профиль.ПортPOP3 =110;
		Профиль.ПортSMTP = 25;
		Профиль.Пользователь ="serv_its@1c-minsk.by";
		Профиль.Пароль ="ServiceITS16";

		Почта = Новый ИнтернетПочта;
		Почта.Подключиться(Профиль);
		МассиЗаголовков = новый Массив;
		МассиЗаголовков.Добавить("Банки");
		МассиЗаголовков.Добавить("Классификатор банков");
		
		МассивСообщений = Почта.Выбрать(Ложь);
		 
		Если МассивСообщений.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		ИмяФайлаСообщения = "";
		
		ЕстьКлассификатор = Ложь;
		Для Индекс = 0 По МассивСообщений.Количество() - 1 Цикл  		
			
			Тема = "Классификатор банков";
			Если МассивСообщений[Индекс].Тема = Тема Тогда
				ИмяВременногФайла = ПолучитьИмяВременногоФайла("xls");
				Попытка
					МассивСообщений[Индекс].Вложения[0].Данные.Записать(ИмяВременногФайла);
					МассивУдаляемыхСообщений = Новый Массив;
					МассивУдаляемыхСообщений.Добавить(МассивСообщений[Индекс]);
					Почта.УдалитьСообщения(МассивУдаляемыхСообщений);
					ЕстьКлассификатор = истина;
				Исключение
					Возврат;
				КонецПопытки;
			КонецЕсли;
			
		КонецЦикла;
		
		Почта.Отключиться();
		
		Если НЕ  ЕстьКлассификатор Тогда
			Возврат;
		КонецЕсли;
		
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.Прочитать(ИмяВременногФайла, СпособЧтенияЗначенийТабличногоДокумента.Значение);    
		
		КолвоСтрокФайла = ТабличныйДокумент.ВысотаТаблицы-1;
		КонечнаяКолонка = ТабличныйДокумент.ПолучитьОбласть().ШиринаТаблицы;
		
		Если КолвоСтрокФайла = 0 Тогда
			ТабличныйДокумент = Неопределено;
		КонецЕсли;
		
		//МакетНовыйБик = Справочники.КлассификаторБанков.ПолучитьМакет("МакетНовыйБИК");
		//ОбластьБИК = МакетНовыйБик.ПолучитьОбласть("БИК");
		//
		//СоответствиеБИК = Новый Соответствие;
		//
		//Для   ит = 1 по 540 Цикл
		//	Если  ОбластьБИК.Область(ит,1,ит,1).Текст = ""
		//		И  ОбластьБИК.Область(ит,2,ит,2).Текст = "" Тогда Прервать;
		//	КонецЕсли;	
		//	бик = ОбластьБИК.Область(ит,1,ит,1).Текст ;
		//	Новйбик = ОбластьБИК.Область(ит,2,ит,2).Текст ;
		//	СоответствиеБИК.Вставить(Новйбик,бик);
		//КонецЦикла;
		

		Макет = Справочники.КлассификаторБанков.ПолучитьМакет("Макет");
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		
		Запись = Новый ЗаписьXML;
		Запись.УстановитьСтроку("UTF-8");
		Запись.ЗаписатьНачалоЭлемента("Items");
		Запись.ЗаписатьАтрибут("Description", "Банки");
		Запись.ЗаписатьАтрибут("Columns", "БИК,НаименованиеПолное,Адрес,КодГорода,Телефоны");
		
		КоличествоВФайле = 0;
		
		Для ит = 9 ПО КолвоСтрокФайла Цикл
			
			нстр = СтрЗаменить(ит, Символы.НПП, "");
			Если Найти(ТабличныйДокумент.ПолучитьОбласть("R"+ нстр + "C2").ТекущаяОбласть.Текст, "область") <> 0 Тогда
				Продолжить
			КонецЕсли;
			
			
			Если  ТабличныйДокумент.ПолучитьОбласть("R"+ нстр + "C8").ТекущаяОбласть.Текст = "" И
				ТабличныйДокумент.ПолучитьОбласть("R"+ нстр + "C6").ТекущаяОбласть.Текст = "" и ит>700 Тогда
				Прервать;
			КонецЕсли;	
			
			Запись.ЗаписатьНачалоЭлемента("Item");	
			Запись.ЗаписатьАтрибут("БИК", ТабличныйДокумент.ПолучитьОбласть("R"+ нстр + "C3").ТекущаяОбласть.Текст);
			Запись.ЗаписатьАтрибут("НаименованиеПолное", ТабличныйДокумент.ПолучитьОбласть("R"+ нстр + "C8").ТекущаяОбласть.Текст);
			Запись.ЗаписатьАтрибут("Адрес",  	ТабличныйДокумент.ПолучитьОбласть("R"+ нстр + "C9").ТекущаяОбласть.Текст);
			Запись.ЗаписатьАтрибут("КодГорода", ТабличныйДокумент.ПолучитьОбласть("R"+ нстр + "C10").ТекущаяОбласть.Текст);
			Запись.ЗаписатьАтрибут("Телефоны", ТабличныйДокумент.ПолучитьОбласть("R"+ нстр + "C11").ТекущаяОбласть.Текст);			
			Запись.ЗаписатьКонецЭлемента();
			
			КоличествоВФайле = КоличествоВФайле + 1;
		КонецЦикла;
		
		Запись.ЗаписатьКонецЭлемента();
		НачатьТранзакцию();
		Справочник = Справочники.КлассификаторБанков.КлассификаторБанков.ПолучитьОбъект();
		Справочник.Текст = Запись.Закрыть();
		Справочник.ДатаКлассификатораБанков = ТекущаяДата();
		Справочник.Записать();
		
		// Проверка загрузки в классификатор Начало		
		КлассификаторГородовXML = Справочники.КлассификаторБанков.ПолучитьМакет("КодыГородовБанков").ПолучитьТекст();
	
		КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(Справочник.текст).Данные;
		КлассификаторГородовТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторГородовXML).Данные;
		
		СписокГородов = Новый ТаблицаЗначений;
		СписокГородов.Колонки.Добавить("Код", Новый ОписаниеТипов("Строка"));
		СписокГородов.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
		
		СписокБанков = Новый ТаблицаЗначений;
		СписокБанков.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
		СписокБанков.Колонки.Добавить("БИК", Новый ОписаниеТипов("Строка"));
		СписокБанков.Колонки.Добавить("КоррСчет", Новый ОписаниеТипов("Строка"));
		СписокБанков.Колонки.Добавить("Город", Новый ОписаниеТипов("Строка"));
		СписокБанков.Колонки.Добавить("Регион", Новый ОписаниеТипов("Строка"));
		СписокБанков.Колонки.Добавить("КодРегиона", Новый ОписаниеТипов("Строка"));
		СписокБанков.Колонки.Добавить("Выбран", Новый ОписаниеТипов("Строка"));
		СписокБанков.Колонки.Добавить("Адрес", Новый ОписаниеТипов("Строка"));
		СписокБанков.Колонки.Добавить("Телефоны", Новый ОписаниеТипов("Строка"));
		СписокБанков.Колонки.Добавить("КодБанка", Новый ОписаниеТипов("Строка"));
		СписокБанков.Колонки.Добавить("КодГорода", Новый ОписаниеТипов("Строка"));
		
		Для Каждого ЗаписьКГ Из КлассификаторГородовТаблица Цикл
			НоваяСтрока = СписокГородов.Добавить();
			НоваяСтрока.Наименование	   = ЗаписьКГ.Наименование;
			НоваяСтрока.Код				   = ЗаписьКГ.Код;
		КонецЦикла;	
		
		КоличествоЭлементов = 0;
		Для Каждого ЗаписьОКВ Из КлассификаторТаблица Цикл
			НоваяСтрока = СписокБанков.Добавить();
			НоваяСтрока.Наименование	   = ЗаписьОКВ.НаименованиеПолное;
			НоваяСтрока.БИК				   = ЗаписьОКВ.БИК;
			НоваяСтрока.Адрес		       = ЗаписьОКВ.Адрес;
			НоваяСтрока.Телефоны		   = ЗаписьОКВ.Телефоны;
			КодГорода                      = ЗаписьОКВ.КодГорода;
			
			Если ЗначениеЗаполнено(КодГорода) Тогда
				СтрГород = КлассификаторГородовТаблица.Найти(КодГорода, "Код");
				Если  СтрГород <> Неопределено Тогда
					НоваяСтрока.Город		       = "г. " + СтрГород.Наименование;
				КонецЕсли;
			КонецЕсли;
			
			НоваяСтрока.КодБанка		   = Прав(ЗаписьОКВ.БИК,3);
			НоваяСтрока.Выбран	           = Ложь;
		КонецЦикла;

		Обработано = 0;
		
		Выборка = Справочники.КлассификаторБанков.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			Если Выборка.Предопределенный Тогда
				Продолжить;
			КонецЕсли;
			ОбъектСпр = Выборка.ПолучитьОбъект();
			ОбъектСпр.Удалить();
		КонецЦикла;
		
		
		Для Каждого СтрокаТаблицы Из СписокБанков Цикл
			Обработано = Обработано + 1;
			//НайденныйБанк = Справочники.КлассификаторБанков.НайтиПоНаименованию(СтрокаТаблицы.Наименование);
			//Если Не ЗначениеЗаполнено(НайденныйБанк) Тогда
			
			БанкОбъект = Справочники.КлассификаторБанков.СоздатьЭлемент();
			ЗаполнитьЗначенияСвойств(БанкОбъект, СтрокаТаблицы);
			БанкОбъект.Код = СтрокаТаблицы.БИК;
			БанкОбъект.Записать();
			//КонецЕсли;
			//КоличествоЭлементов = КоличествоЭлементов + 1;
			
		КонецЦикла; 
		
		ЗафиксироватьТранзакцию();
		// Проверка загрузки в классификатор Конец
		
		УдалитьФайлы(ИмяВременногФайла);	
		
		Константы.ДатаОбновленияКлассификаторБанков.Установить(ТекущаяДата());

	    Профиль = новый ИнтернетПочтовыйПрофиль;
	    Профиль.АдресСервераSMTP = "mail.1c-minsk.by";
	    Профиль.ПользовательSMTP ="serv_its@1c-minsk.by";
	    Профиль.ПарольSMTP ="ServiceITS16";
	    Профиль.ПортSMTP = 25;
	    Профиль.АдресСервераSMTP = СпособSMTPАутентификации.Login;
		
		Почта = Новый ИнтернетПочта;
		
		Письмо = Новый ИнтернетПочтовоеСообщение;
		Текст = Письмо.Тексты.Добавить("Загрузка  классификатора банков от "+ТекущаяДата()+" выполнена");
		Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
		Письмо.Тема = "Загрузка классификатора банков выполнена. В файле " + Строка(КоличествоВФайле) + " загружено " + Строка(Обработано) ; 
		Письмо.Отправитель = "serv_its@1c-minsk.by";
		Письмо.ИмяОтправителя = "КлассификаторБанков";
		//Письмо.Получатели.Добавить("1cServic@mail.ru");
		Письмо.Получатели.Добавить("savo@1c-minsk.by");
		Письмо.Получатели.Добавить("inna.scorpio@gmail.com");
		Почта.Подключиться(Профиль);
		Почта.Послать(Письмо);
		Почта.Отключиться();
		
		
		
	Исключение
		
		Если ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли;	
			
	    Профиль = новый ИнтернетПочтовыйПрофиль;
	    Профиль.АдресСервераSMTP = "mail.1c-minsk.by";
	    Профиль.ПользовательSMTP ="serv_its@1c-minsk.by";
	    Профиль.ПарольSMTP ="ServiceITS16";
	    Профиль.ПортSMTP = 25;
	    Профиль.АдресСервераSMTP = СпособSMTPАутентификации.Login;
	    
	    Почта = Новый ИнтернетПочта;
	    
	    Письмо = Новый ИнтернетПочтовоеСообщение;
	    Текст = Письмо.Тексты.Добавить(ОписаниеОшибки());
	    Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
	    Письмо.Тема = "Ошибка загрузки классификатора банков!"; 
	    Письмо.Отправитель = "serv_its@1c-minsk.by";
	    Письмо.ИмяОтправителя = "КлассификаторБанков";
		Письмо.Получатели.Добавить("1cServic@mail.ru");
		Письмо.Получатели.Добавить("savo@1c-minsk.by");
	    Письмо.Получатели.Добавить("inna.scorpio@gmail.com");	
	    Почта.Подключиться(Профиль);
	    Почта.Послать(Письмо);
	    Почта.Отключиться();
		
	КонецПопытки;
	
КонецПроцедуры



