
Функция ПроверитьРегистрациюКорреспондента(РегистрационныйНомер, ЛогинПользователя = "", ПериодДействия, КодОшибки, Отказ) Экспорт
	
	//Создаем прокси для обращения к внешнему веб-сервису,
	// передаем в функцию URI пространства имен, имя сервиса, имя порта.
	WSПрокси = WSСсылки.ITS.СоздатьWSПрокси(
	"http://api.repository.onec.ru", "PartnerSubscriptionApiServiceImplService", "PartnerSubscriptionApiServiceImplPort");
	
	WSПрокси.Пользователь = "api-login-17448";
	WSПрокси.Пароль       = "52446717a7124b";
	
	Операции = WSПрокси.ТочкаПодключения.Интерфейс.Операции;
	
	ТипПараметра1 = Операции[1].Параметры[0].Тип;
	ТипПараметра1_1 = Операции[1].Параметры[0].Тип.Свойства[0].Тип;
	
	ТипПараметра2 = Операции[0].Параметры[0].Тип;
	ТипПараметра2_1 = Операции[0].Параметры[0].Тип.Свойства[0].Тип;
	
	Результат1 = Неопределено;
	Результат2 = Неопределено;
	
	ПараметрМетода1 = WSПрокси.ФабрикаXDTO.Создать(ТипПараметра1);
	ПараметрМетода1_1 = WSПрокси.ФабрикаXDTO.Создать(ТипПараметра1_1);
	ПараметрМетода2 = WSПрокси.ФабрикаXDTO.Создать(ТипПараметра2);
	ПараметрМетода2_1 = WSПрокси.ФабрикаXDTO.Создать(ТипПараметра2_1);
	
	Если РегистрационныйНомер <> "" Тогда
		ПараметрМетода1_1.regNumList.Добавить(РегистрационныйНомер);
		ПараметрМетода1.regNumList = ПараметрМетода1_1;
		Результат1 = WSПрокси.checkItsByRegNum(ПараметрМетода1);		
	КонецЕсли;
	
	Если ЛогинПользователя <> "" Тогда
		ПараметрМетода2_1.loginList.Добавить(ЛогинПользователя);
		ПараметрМетода2.loginList = ПараметрМетода2_1;
		Результат2 = WSПрокси.checkItsByLogin (ПараметрМетода2);
		
	КонецЕсли;
	
	Если Результат1 <> Неопределено Тогда
		
		РезультатПроверкиРегистрНомера = Результат1.return[0].description;
		ТекущаяДата = ТекущаяДатаСеанса();
		
		Если Результат1.return[0].status = "Success"  Тогда
			
			Для каждого текСтрока ИЗ   Результат1.return[0].subscriptionInfoList Цикл
				Если   текСтрока.startdate >=  ТекущаяДата   Тогда
					Продолжить;
				ИначеЕсли  текСтрока.enddate <=  ТекущаяДата ТОгда
					Продолжить;
				Иначе
					ПериодДействия = текСтрока.endDate; 
					Прервать
				КонецЕсли;
				
			КонецЦикла;	
			
		Иначе	
			Отказ = Истина;
			КодОшибки = ВРЕГ(Результат1.return[0].status);
		КонецЕсли;
		
		Возврат РезультатПроверкиРегистрНомера;
		
		//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатПроверкиРегистрНомера,,,,Отказ);
	КонецЕсли;
	
	Если Результат2 <> Неопределено Тогда
		РезультатПроверкиЛогина =  Результат2.return[0].description;
		
		Если Результат2.return[0].status = "Success"  Тогда
			ПериодДействия = Результат2.return[0].subscriptionInfoList[0].endDate;
		Иначе	
			Отказ = Истина;
			КодОшибки = ВРЕГ(Результат1.return[0].status);
			//Результат1.return[0].subscriptionInfoList[1].endDate	
		КонецЕсли;
		
		
		Возврат РезультатПроверкиРегистрНомера;
		//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатПроверкиЛогина,,,,Отказ);
	КонецЕсли;
	
	
	
КонецФункции	

Процедура ПроверитьПодпискуИТС(СтруктураПараметров, КодОшибки, Отказ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	С_РегистрацияИТССрезПоследних.ИНН,
		|	С_РегистрацияИТССрезПоследних.РегистрационныйНомер,
		|	С_РегистрацияИТССрезПоследних.ДатаПо,
		|	С_РегистрацияИТССрезПоследних.ДатаС,
		|	С_РегистрацияИТССрезПоследних.РучнойВвод
		|ИЗ
		|	РегистрСведений.С_РегистрацияИТС.СрезПоследних(
		|			&ДатаПроверки,
		|			ИНН = &ИНН
		|				И РегистрационныйНомер = &РегистрационныйНомер) КАК С_РегистрацияИТССрезПоследних";
		
	Запрос.УстановитьПараметр("ИНН", СтруктураПараметров.ID_ORG_UNP);
	Запрос.УстановитьПараметр("РегистрационныйНомер", СтруктураПараметров.ID_ITS_REGNUM);
	Запрос.УстановитьПараметр("ДатаПроверки", СтруктураПараметров.РабочаяДата);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Отказ = Истина;
		КодОшибки = "AGREEMENTNOTEXISTS";					
	КонецЕсли;
	
КонецПроцедуры	

Функция ПолучитьПериодДействияИТС(РегистрационныйНомер, ИНН) ЭКспорт

	СтруктураПериодаИТС = Новый Структура;
	СтруктураПериодаИТС.Вставить("ДатаС",  Дата(1,1,1));
	СтруктураПериодаИТС.Вставить("ДатаПо", Дата(1,1,1));	
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	С_РегистрацияИТССрезПоследних.ИНН,
	|	С_РегистрацияИТССрезПоследних.РегистрационныйНомер,
	|	С_РегистрацияИТССрезПоследних.ДатаПо,
	|	С_РегистрацияИТССрезПоследних.ДатаС
	|ИЗ
	|	РегистрСведений.С_РегистрацияИТС.СрезПоследних(
	|			,
	|			ИНН = &ИНН
	|				И РегистрационныйНомер = &РегистрационныйНомер) КАК С_РегистрацияИТССрезПоследних" ;
	
	Запрос.УстановитьПараметр("ИНН", ИНН);
	Запрос.УстановитьПараметр("РегистрационныйНомер", РегистрационныйНомер);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтруктураПериодаИТС.ДатаС = ВыборкаДетальныеЗаписи.ДатаС;
		СтруктураПериодаИТС.ДатаПо = ВыборкаДетальныеЗаписи.ДатаПо;
	КонецЦикла;
	
	Возврат СтруктураПериодаИТС
КонецФункции

Процедура ОчиститьРегистрИТС() Экспорт
	// Вставить содержимое обработчика.
КонецПроцедуры
