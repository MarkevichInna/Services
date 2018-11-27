
Функция УстановитьСоединениеССерверомEPASS(КодОшибки, Отказ) Экспорт
	
			
	Попытка
		
		Соединение = Новый HTTPСоединение("www.epass.by");
		
	Исключение
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Установка соединения с сервером epass.by."),
								УровеньЖурналаРегистрации.Ошибка,
								,
								,
								НСтр("ru = 'Не удалось установить соединение с сервером epass.by."));

		КодОшибки = "EPASS_ACCESS_ERROR"; 	
		Отказ = Истина;
		Возврат Неопределено;
		
	КонецПопытки;
	
	Возврат  Соединение;
	
КонецФункции	

Функция НачатьСессиюНаСервисеEPass(Логин, Пароль, КодОшибки, Отказ) Экспорт
	
	Соединение =  УстановитьСоединениеССерверомEPASS(КодОшибки, Отказ);
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяВыходногоФайла = ПолучитьИмяВременногоФайла();
	ИдентификаторСессии = "";	
	ЗаголовкиХТТП = Новый Соответствие;
	ЗаголовкиХТТП.Вставить("Content-Type", "text/xml;charset=UTF-8");
	ЗаголовкиХТТП.Вставить("SOAPAction", "");
	
	ХТТПЗапрос = Новый HTTPЗапрос("/BEPTGlobalService", ЗаголовкиХТТП);
	
	ТелоЗапроса = ПолучитьОбщийМакет("Login").ПолучитьТекст();
	ТелоЗапроса = СтрЗаменить(ТелоЗапроса, "id_password", Пароль);
	ТелоЗапроса = СтрЗаменить(ТелоЗапроса, "id_username", Логин);                           
	ХТТПЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	
	Попытка
		Соединение.ОтправитьДляОбработки(ХТТПЗапрос, ИмяВыходногоФайла);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Попытка вторизации на сервере epass.by.'"),УровеньЖурналаРегистрации.Ошибка, ,	, НСтр("ru = 'Ошибка попытки авторизации на сервере epass.by.'"));
		КодОшибки = "EPASS_LOGIN_ERROR";
		Отказ = Истина;
	КонецПопытки;
	
	Если Отказ Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	//Чтение ответа сервера
	ЧтениеХМЛ = Новый ЧтениеXML;
	ЧтениеХМЛ.ОткрытьФайл(ИмяВыходногоФайла);
	Пока ЧтениеХМЛ.Прочитать() Цикл
		
		Если ЧтениеХМЛ.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеХМЛ.Имя = "errorCode" Тогда
			ЧтениеХМЛ.Прочитать();
			КодОшибки = ЧтениеХМЛ.Значение;
			Если КодОшибки <> "OK" Тогда
								
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка авторизации на сервере epass.by.'"),
								УровеньЖурналаРегистрации.Ошибка,
								,
								,
								ОбработатьКодОшибки(КодОшибки));
				Отказ = Истина;
				Прервать;
			КонецЕсли;
		КонецЕсли;							
		
		Если ЧтениеХМЛ.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеХМЛ.Имя = "sessiontoken" Тогда
			ЧтениеХМЛ.Прочитать();
			ИдентификаторСессии = ЧтениеХМЛ.Значение;
			Прервать;
		КонецЕсли; 
		
	КонецЦикла;
	
	ЧтениеХМЛ.Закрыть();
	
	УдалитьФайлы(ИмяВыходногоФайла);
	
	Возврат ИдентификаторСессии;
	
КонецФункции

Процедура ЗавершитьСессиюНаСервереEPass(ИдентификаторСессии, КодОшибки, Отказ) Экспорт
	
    Соединение = УстановитьСоединениеССерверомEPASS(КодОшибки, Отказ);	
	
	Если  Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаголовкиХТТП = Новый Соответствие;
	ЗаголовкиХТТП.Вставить("Content-Type", "text/xml;charset=UTF-8");
	ЗаголовкиХТТП.Вставить("SOAPAction", "");
	
	ХТТПЗапрос = Новый HTTPЗапрос("/BEPTGlobalService", ЗаголовкиХТТП);
	
	ТелоЗапроса = ПолучитьОбщийМакет("Logout").ПолучитьТекст();
	ТелоЗапроса = СтрЗаменить(ТелоЗапроса, "id_sessiontoken", ИдентификаторСессии);
	ХТТПЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	
	Попытка
		
		Соединение.ОтправитьДляОбработки(ХТТПЗапрос,);
		
	Исключение
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отключение от сервера epass.by.'"),
								УровеньЖурналаРегистрации.Ошибка,
								,
								,
								НСтр("ru = 'Ошибка отключения от сервера epass.by.'"));

		КодОшибки = "EPASS_ACCESS_BREAK_ERROR";						
		Отказ = Истина;
		
	КонецПопытки;
	
КонецПроцедуры	

Функция ВыполнитьМетодСервисаEPASS(ТелоЗапроса, КодОшибки, Отказ)Экспорт
	
	ИмяВыходногоФайла = ПолучитьИмяВременногоФайла();
	
    Соединение =  ЕПАССервер.УстановитьСоединениеССерверомEPASS(КодОшибки, Отказ);	
	
	Если Отказ Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	ЗаголовкиХТТП = Новый Соответствие;
	ЗаголовкиХТТП.Вставить("Content-Type", "text/xml;charset=UTF-8");
	ЗаголовкиХТТП.Вставить("SOAPAction", "");
	
	ХТТПЗапрос = Новый HTTPЗапрос("/BEPTGlobalService", ЗаголовкиХТТП);
	ХТТПЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	
	Попытка
		
		Соединение.ОтправитьДляОбработки(ХТТПЗапрос, ИмяВыходногоФайла);
		
	Исключение
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Выполнение запроса к сервису EPASS'"),
								УровеньЖурналаРегистрации.Ошибка,
								,
								,
								НСтр("ru = 'Не удалось выполнить запрос на сервере epass.by'"));
		КодОшибки =  "EPASS_REQUEST_ERROR";
	    Отказ = Истина;
		
	КонецПопытки;
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;	
	
	ЧтениеХМЛ = Новый ЧтениеXML;
	ЧтениеХМЛ.ОткрытьФайл(ИмяВыходногоФайла);
	Пока ЧтениеХМЛ.Прочитать() Цикл
		
		Если ЧтениеХМЛ.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеХМЛ.Имя = "errorCode" Тогда
			ЧтениеХМЛ.Прочитать();
			КодОшибки = ЧтениеХМЛ.Значение;
			Если КодОшибки <> "OK" Тогда		
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Чтение результата запроса к сервису EPASS'"), УровеньЖурналаРегистрации.Ошибка,,, ЕПАССервер.ОбработатьКодОшибки(КодОшибки));
				Отказ = Истина;
				Прервать;
			Иначе
				Прервать;
			КонецЕсли;
			
		КонецЕсли;							
		
	КонецЦикла;
	
	ЧтениеХМЛ.Закрыть();
	
	Возврат ИмяВыходногоФайла;
	
КонецФункции	

Процедура СформироватьJSON(ОбъектXDTO, ИмяОбъектаXDTO, ЗаписьJSON, Отказ)Экспорт
	

	СвойстваОбъекта = Новый Массив;
	
	Для Каждого Стр Из ОбъектXDTO.Свойства() Цикл
		СвойстваОбъекта.Добавить(Стр);
	КонецЦикла;
	
	Попытка
	
		Для Каждого Элт ИЗ СвойстваОбъекта Цикл 
			
			Если ТипЗнч(ОбъектXDTO[Элт.Имя]) = Тип("ОбъектXDTO") Тогда
				
				ЗаписьJSON.ЗаписатьИмяСвойства(Элт.Имя);
				ЗаписьJSON.ЗаписатьНачалоОбъекта();
				СформироватьJSON(ОбъектXDTO[Элт.Имя], Элт.Имя, ЗаписьJSON, Отказ);
				
			ИначеЕсли  ТипЗнч(ОбъектXDTO[Элт.Имя]) = Тип("СписокXDTO") Тогда
				
				ЗаписьJSON.ЗаписатьИмяСвойства(Элт.Имя);
				КоличествоСписка= ОбъектXDTO[Элт.Имя].Количество();
				сч = 0;			
				ЗаписьJSON.ЗаписатьНачалоМассива();
				
				Для каждого элтСписка  ИЗ  ОбъектXDTO[Элт.Имя] Цикл
					ЗаписьJSON.ЗаписатьНачалоОбъекта();
					СформироватьJSON(элтСписка, Элт.Имя, ЗаписьJSON, Отказ);
				КонецЦикла;
				
				ЗаписьJSON.записатьКонецМассива();
				//ЗаписьJSON.ЗаписатьКонецОбъекта();
			Иначе
				
				
				ЗаписьJSON.ЗаписатьИмяСвойства(Элт.Имя);
				ЗаписьJSON.ЗаписатьЗначение(ОбъектXDTO[Элт.Имя]);
				
			КонецЕсли;
		КонецЦикла;
		
		ЗаписьJSON.ЗаписатьКонецОбъекта();
		
	Исключение
		
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Формирование результата запроса в формате JSON'"),
								УровеньЖурналаРегистрации.Ошибка,
								,
								,
								НСтр("ru = 'Ошибка при формировании результата запроса в формате JSON'"));

		Отказ = Истина;
							
		
	КонецПопытки; 
							
	
КонецПроцедуры

Функция ОбработатьКодОшибки(КодОшибки)Экспорт 
	
	Код = "";	
	
	Если КодОшибки = "INVALID_USERNAME" Тогда
		Код = НСтр("ru = 'Некорректный идентификатор'");
	ИначеЕсли КодОшибки = "INVALID_PASSWORD" Тогда
		Код = НСтр("ru = 'Неправильный пароль'");
	ИначеЕсли КодОшибки = "INVALID_USERNAME_OR_PASSWORD" Тогда
		Код = НСтр("ru = 'Неверное имя пользователя либо пароль'");
	ИначеЕсли КодОшибки = "NO_ACCESS" Тогда
		Код = НСтр("ru = 'Нет прав для пользования сервисами'");
	ИначеЕсли КодОшибки = "INVALID_GLN" Тогда
		Код = НСтр("ru = 'Неправильный GLN (GLN должен состоять из 13 цифр)'");
	ИначеЕсли КодОшибки = "GLN_DONT_EXIST" Тогда
		Код = НСтр("ru = 'Производителя с выбранным GLN в системе не имеется'");
	ИначеЕсли КодОшибки = "INVALID_GTIN" Тогда
		Код = НСтр("ru = 'Неправильный GTIN (GTIN должен состоять из 13 цифр)'");
	ИначеЕсли КодОшибки = "GTIN_DONT_EXIST" Тогда
		Код = НСтр("ru = 'Товара с выбранным GTIN в системе не имеется'");
	ИначеЕсли КодОшибки = "ENDED_QUOTA" Тогда
		Код = НСтр("ru = 'Нет квоты на получение информации о товаре'");
	ИначеЕсли КодОшибки = "OTHER" Тогда
		Код = НСтр("ru = 'Остальное'");	
	ИначеЕсли КодОшибки = "EPASS_ACCESS_ERROR" Тогда
		Код = НСтр("ru = 'Не удалось установить соединение с сервером epass.by.");	
	ИначеЕсли КодОшибки = "EPASS_LOGIN_ERROR" Тогда
		Код = НСтр("ru = 'Ошибка попытки авторизации на сервере epass.by.'");		
	ИначеЕсли КодОшибки = "EPASS_ACCESS_BREAK_ERROR" Тогда
		Код = НСтр("ru = 'Не удалось разорвать соединение с сервером epass.by.");	
    ИначеЕсли КодОшибки = "EPASS_REQUEST_ERROR" Тогда
		Код =НСтр("ru = 'Не удалось выполнить запрос на сервере epass.by'");	
		
	 ИначеЕсли КодОшибки = "EPASS_REQUEST_PROCESS_ERROR" Тогда
		Код =НСтр("ru = 'Не удалось обработать результат запроса к серверу epass.by'");	
	ИначеЕсли КодОшибки = "ERROR_JSON" Тогда
		Код = НСтр("ru = 'Ошибка при формировании результата запроса в формате JSON'");	

	КонецЕсли;	
		
	Возврат Код;	
	
КонецФункции
