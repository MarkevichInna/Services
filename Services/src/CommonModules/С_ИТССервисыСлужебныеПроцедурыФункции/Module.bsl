
Функция ПолучитьЗаписьXML()Экспорт	
	ЗаписьXML = Новый ЗаписьXML();
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьXML.ЗаписатьНачалоЭлемента("Result");
	Возврат ЗаписьXML	
КонецФункции	

Процедура ДобавитьЭлементXML(ЗаписьXML, ИмяЭлемента, ЗначениеЭлемента)  Экспорт
	
	ЗаписьXML.ЗаписатьНачалоЭлемента(ИмяЭлемента);
	ЗаписьXML.ЗаписатьТекст(ЗначениеЭлемента);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры	

Процедура ДополнитьОписаниеОшибки(ЗаписьXML, КодОшибки, ЗаголовокОшибки, ОписаниеОшибки)Экспорт
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Error");
		ЗаписьXML.ЗаписатьНачалоЭлемента("Code");
			ЗаписьXML.ЗаписатьТекст(КодОшибки); 
		ЗаписьXML.ЗаписатьКонецЭлемента();
	
		ЗаписьXML.ЗаписатьНачалоЭлемента("Head");
			ЗаписьXML.ЗаписатьТекст(ЗаголовокОшибки); 
		ЗаписьXML.ЗаписатьКонецЭлемента();
	
		ЗаписьXML.ЗаписатьНачалоЭлемента("Description");
			ЗаписьXML.ЗаписатьТекст(ОписаниеОшибки); 
		ЗаписьXML.ЗаписатьКонецЭлемента();
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры	

Процедура  ДополнитьПустяеЗаписиПриОшибке(ЗаписьXML, ЕстьЗапрос = Истина)Экспорт
	Если ЕстьЗАпрос Тогда
		ЗаписьXML.ЗаписатьНачалоЭлемента("IDRequest");
		ЗаписьXML.ЗаписатьТекст("");
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЕсли;
	
	//ЗаписьXML.ЗаписатьНачалоЭлемента("Service");
	//	ЗаписьXML.ЗаписатьНачалоЭлемента("Items");
	//	ЗаписьXML.ЗаписатьКонецЭлемента();
	//ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры	

Функция ПолучитьСтруктуруПараметровЗапроса(ВходныеДанные)Экспорт
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("DATEBEGIN", Дата('20150101'));
	СтруктураПараметров.Вставить("DATEEND", Дата('20150101'));
    СтруктураПараметров.Вставить("REGNUMBERS");
	СтруктураПараметров.Вставить("INN", "");
	СтруктураПараметров.Вставить("IDCUSTOMER", "");
	СтруктураПараметров.Вставить("NAMECUSTOMER", "");
	СтруктураПараметров.Вставить("PARTNERCODE", "");
	СтруктураПараметров.Вставить("IDREQUEST", "");
	СтруктураПараметров.Вставить("IDDOCREQUEST", "");
	СтруктураПараметров.Вставить("IDSERVICEVA", "");
	СтруктураПараметров.Вставить("IDSERVICE", "");
	СтруктураПараметров.Вставить("PARAMETERS", "");

	Попытка
		Для каждого элт Из  ВходныеДанные.свойства() Цикл
			Значение = ВходныеДанные[элт.Имя];			
			Если  ВРЕГ(элт.Имя) = "DATEBEGIN" Тогда
			    Попытка
					СтруктураПараметров["DATEBEGIN"] = Дата(Значение);
				Исключение
					// ОтослатьПисьмо("СтруктураПараметровDATEBEGIN", СтруктураПараметров.ТелоЗапроса, ОписаниеОшибки());
				КонецПопытки;	
			ИначеЕсли 	ВРЕГ(элт.Имя) = "DATEEND" Тогда
				Попытка
					СтруктураПараметров["DATEEND"] = Дата(Значение);
				Исключение
					 //ОтослатьПисьмо("СтруктураПараметровDATEBEGIN", СтруктураПараметров.ТелоЗапроса, ОписаниеОшибки());
				КонецПопытки;
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "REGNUMBERS" Тогда
				СтруктураПараметров["REGNUMBERS"] = Значение;
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "INN" Тогда
				СтруктураПараметров["INN"] =  Значение;
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "IDCUSTOMER" Тогда
				СтруктураПараметров["IDCUSTOMER"] = Значение;
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "NAMECUSTOMER" Тогда
				СтруктураПараметров["NAMECUSTOMER"] =  Значение;
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "PARTNERCODE" Тогда
				СтруктураПараметров["PARTNERCODE"] =  Значение;
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "IDREQUEST" Тогда
				СтруктураПараметров["IDREQUEST"] =  Значение;
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "IDDOCREQUEST" Тогда
				СтруктураПараметров["IDDOCREQUEST"] = Значение;	
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "IDSERVICEVA" Тогда
				СтруктураПараметров["IDSERVICEVA"] =  Значение;
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "IDSERVICE" Тогда
				СтруктураПараметров["IDSERVICE"] =  Значение;
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "PARAMETERS" Тогда
				СтруктураПараметров["PARAMETERS"] =  Значение;

			КонецЕсли;
		КонецЦикла;	
	Исключение	
		//ОтослатьПисьмо("ПолучитьСтруктуруПараметровЗапроса",СтруктураПараметров.ТелоЗапроса, ОписаниеОшибки());
	КонецПопытки;
	
	Возврат СтруктураПараметров;
КонецФункции	

Функция РазложитьСтрокуВМассивПодстрок(Знач Значение, Знач Разделитель = ";", Знач ПропускатьПустыеСтроки = Истина, 
	СокращатьНепечатаемыеСимволы = иСТИНА) Экспорт
	
	Результат = Новый Массив;
	
	// Для обеспечения обратной совместимости.
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Значение) Тогда 
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	//
	
	Позиция = СтрНайти(Значение, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Значение, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Если СокращатьНепечатаемыеСимволы Тогда
				Результат.Добавить(СокрЛП(Подстрока));
			Иначе
				Результат.Добавить(Подстрока);
			КонецЕсли;
		КонецЕсли;
		Значение = Сред(Значение, Позиция + СтрДлина(Разделитель));
		Позиция = СтрНайти(Значение, Разделитель);
	КонецЦикла;
	
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Значение) Тогда
		Если СокращатьНепечатаемыеСимволы Тогда
			Результат.Добавить(СокрЛП(Значение));
		Иначе
			Результат.Добавить(Значение);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 

Процедура ОбработатьВхПараметры(Запрос, ЗаписьXML, СтруктураПараметров, Отказ)Экспорт
	
	ТелоЗапроса = Запрос.ПолучитьТелоКакСтроку(Кодировкатекста.UTF8);
	ЧтениеXML =   Новый ЧтениеXML();
	ЧтениеXML.УстановитьСтроку(ТелоЗапроса);
	
	Попытка
		ВходныеДанные = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("DATEBEGIN", Дата(1,1,1));
		СтруктураПараметров.Вставить("DATEEND", Дата(1,1,1));
		СтруктураПараметров.Вставить("Error", "");

		СтруктураПараметров.Вставить("REGNUMBERS");
		СтруктураПараметров.Вставить("INN", "");
		
		СтруктураПараметров.Вставить("IDCUSTOMER", "");
		СтруктураПараметров.Вставить("NAMECUSTOMER", "");
		
		СтруктураПараметров.Вставить("PARTNERCODE", "");
		СтруктураПараметров.Вставить("IDREQUEST", "");
		СтруктураПараметров.Вставить("IDDOCREQUEST", "");
		
		СтруктураПараметров.Вставить("IDSERVICEVA", "");
		СтруктураПараметров.Вставить("IDSERVICE", "");
		
		Для каждого элт Из  ВходныеДанные.свойства() Цикл
			Значение = ВходныеДанные[элт.Имя];
			
			Если  ВРЕГ(элт.Имя) = "DATEBEGIN" Тогда
				СтруктураПараметров["DATEBEGIN"] = Дата(Значение);
				
			ИначеЕсли 	ВРЕГ(элт.Имя) = "DATEEND" Тогда
				СтруктураПараметров["DATEEND"] = Дата(Значение);
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "REGNUMBERS" Тогда
				СтруктураПараметров["REGNUMBERS"] = Значение;
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "UNP" Тогда
				СтруктураПараметров["INN"] =  Значение;				
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "IDCUSTOMER" Тогда
				СтруктураПараметров["IDCUSTOMER"] = Значение;			
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "NAMECUSTOMER" Тогда
				СтруктураПараметров["NAMECUSTOMER"] =  Значение;			
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "PARTNERCODE" Тогда
				СтруктураПараметров["PARTNERCODE"] =  Значение;			
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "IDREQUEST" Тогда
				СтруктураПараметров["IDREQUEST"] =  Значение;				
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "IDDOCREQUEST" Тогда
				СтруктураПараметров["IDDOCREQUEST"] = Значение;					
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "IDSERVICEVA" Тогда
				СтруктураПараметров["IDSERVICEVA"] =  Значение;				
				
			ИначеЕсли  ВРЕГ(элт.Имя) = "IDSERVICE" Тогда
				СтруктураПараметров["IDSERVICE"] =  Значение;
			КонецЕсли;
		КонецЦикла;	
	Исключение
		Отказ = Истина;
	КонецПопытки;	
	
КонецПроцедуры	

Процедура ОтослатьПисьмо(Тема, ТелоЗапроса, ЗаписьXML, ТемаПисьма = "Ошибка") Экспорт
	Попытка
		Профиль = новый ИнтернетПочтовыйПрофиль;
		Профиль.АдресСервераSMTP = "mail.1c-minsk.by";
		Профиль.ПользовательSMTP ="serv_its@1c-minsk.by";
		Профиль.ПарольSMTP ="ServiceITS16";
		Профиль.ПортSMTP = 25;
		Профиль.АдресСервераSMTP = СпособSMTPАутентификации.Login;
		
		Почта = Новый ИнтернетПочта;
		
		Письмо = Новый ИнтернетПочтовоеСообщение;
		Текст = Письмо.Тексты.Добавить(Тема + "   ");
		Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;	
		Текст = Письмо.Тексты.Добавить(Символы.ПС + Символы.ПС +  "Тело запроса" + Символы.ПС);
		Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;

		Текст = Письмо.Тексты.Добавить(ТелоЗапроса);
		Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
		
		Текст = Письмо.Тексты.Добавить(Символы.ПС + Символы.ПС +"Ответ" + Символы.ПС);
		Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;

		Текст = Письмо.Тексты.Добавить(ЗаписьXML);
		Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
		
		Письмо.Тема = ТемаПисьма; 
		Письмо.Отправитель = "serv_its@1c-minsk.by";
		Письмо.ИмяОтправителя = ТемаПисьма;
		Письмо.Получатели.Добавить("inna.scorpio@gmail.com");	
		Почта.Подключиться(Профиль);
		Почта.Послать(Письмо);
		Почта.Отключиться();
	Исключение
		ЗаписьЖурналаРегистрации("Отправка почты",УровеньЖурналаРегистрации.Ошибка); 
	КонецПопытки;	
	
КонецПроцедуры	

Функция ЭтоБесплатныйСервис(Сервис)
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сервисы.Ссылка,
		|	Сервисы.БесплатныйСервис  КАК  БесплатныйСервис
		|ИЗ
		|	Справочник.С_Сервисы КАК Сервисы
		|ГДЕ
		|	Сервисы.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Сервис);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат   ВыборкаДетальныеЗаписи.БесплатныйСервис;
	КонецЦикла;
		
КонецФункции	