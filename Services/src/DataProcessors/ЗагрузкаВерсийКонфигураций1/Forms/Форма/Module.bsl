
&НаКлиенте
Процедура Загрузить(Команда)
	ЗагрузитьНаСервере();
КонецПроцедуры

Процедура ЗагрузитьнаСервере()
	
	ТабличныйДокумент =  Объект.Версии;
	КолвоСтрокФайла = Объект.Версии.ВысотаТаблицы;
		
	Если КолвоСтрокФайла = 0 Тогда
		ТабличныйДокумент = Неопределено;
	КонецЕсли;
	
	Для ит = 1 ПО КолвоСтрокФайла Цикл
		
		нстр = СтрЗаменить(ит, Символы.НПП, "");
		
		Если  ТабличныйДокумент.ПолучитьОбласть("R"+ нстр + "C1").ТекущаяОбласть.Текст = "" Тогда
			Прервать;
		КонецЕсли;
		
		ВерсияСтр =  СокрЛП(ТабличныйДокумент.ПолучитьОбласть("R"+ нстр + "C1").ТекущаяОбласть.Текст);
		
		Если Найти(ВерсияСтр,",")<>0 тогда
			МассивВерсияСтр = СтрЗаменить(ВерсияСтр,",",Символы.ПС);
			КоличествоСтрок = СтрЧислоСтрок(МассивВерсияСтр);
			
			Для сч = 1 по КоличествоСтрок Цикл
				Запрос = Новый Запрос;
				Запрос.Текст = 
				"ВЫБРАТЬ
				|	С_ВерсииКонфигураций.Ссылка
				|ИЗ
				|	Справочник.С_ВерсииКонфигураций КАК С_ВерсииКонфигураций
				|ГДЕ
				|	С_ВерсииКонфигураций.Версия = &Версия
				|	И С_ВерсииКонфигураций.Конфигурация = &Конфигурация";
				
				Запрос.УстановитьПараметр("Версия", СокрЛП(СтрПолучитьСтроку(МассивВерсияСтр,сч)));
				Запрос.УстановитьПараметр("Конфигурация", Объект.Конфигурация);
				
				РезультатЗапроса = Запрос.Выполнить();
				
				ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
				
				
				Если ВыборкаДетальныеЗаписи.Следующий() Тогда
					Продолжить;
				Иначе
					НовыйЭлт = Справочники.С_ВерсииКонфигураций.СоздатьЭлемент();
					НовыйЭлт.Версия = Строка(СокрЛП(СтрПолучитьСтроку(МассивВерсияСтр,сч)));
					НовыйЭлт.Конфигурация = Объект.Конфигурация;
					НовыйЭлт.Наименование  = Строка(Объект.Конфигурация) + " " +  Строка(СокрЛП(СтрПолучитьСтроку(МассивВерсияСтр,сч)));
					НовыйЭлт.Записать();
				КонецЕсли;	
				
			КонецЦикла;
			
		Иначе
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	С_ВерсииКонфигураций.Ссылка
			|ИЗ
			|	Справочник.С_ВерсииКонфигураций КАК С_ВерсииКонфигураций
			|ГДЕ
			|	С_ВерсииКонфигураций.Версия = &Версия
			|	И С_ВерсииКонфигураций.Конфигурация = &Конфигурация";
			
			Запрос.УстановитьПараметр("Версия", ВерсияСтр);
			Запрос.УстановитьПараметр("Конфигурация", Объект.Конфигурация);
			РезультатЗапроса = Запрос.Выполнить();
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			Если ВыборкаДетальныеЗаписи.Следующий() Тогда
				Продолжить;
			Иначе
				НовыйЭлт = Справочники.С_ВерсииКонфигураций.СоздатьЭлемент();
				НовыйЭлт.Версия = ВерсияСтр;
				НовыйЭлт.Конфигурация = Объект.Конфигурация;
				НовыйЭлт.Наименование  = Строка(Объект.Конфигурация) + " " +  Строка(ВерсияСтр);
				НовыйЭлт.Записать();
			КонецЕсли;	
			
		КонецЕсли;	
		
		
		
	КонецЦикла;
	
	
	
КонецПроцедуры	