
Функция CheckRegistrationPOST(Запрос)
	
	Отказ = Ложь;
	КодОшибки = "";
	Ответ = Новый HTTPСервисОтвет(200);	
	
	СтруктураПараметров = С_СлужебныеПроцедурыФункцииСервер.РазобратьВходныеданные(Запрос);
	
	С_РаботаССервисамиСлужебный.ПроверитьОбщийДоступКСервисам(СтруктураПараметров,  Ответ, КодОшибки, Отказ);

	Если Отказ Тогда
		Возврат Ответ
	КонецЕсли;
	
	С_РаботаССервисамиСлужебный.ЗарегистрироватьИспользованиеСервиса(СтруктураПараметров, Справочники.С_Сервисы.BanksClassifier, КодОшибки, Отказ);
	
	Если Отказ Тогда
		С_СлужебныеПроцедурыФункцииСервер.УстановитьКодОшибки(Ответ, КодОшибки);
		Возврат Ответ
	КонецЕсли;
	
	ДанныеСервиса =  ПолучитьДанныеСервиса(КодОшибки, Отказ);																
	
	Ответ.Заголовки["Content-Type"] =  "text/xml;charset=UTF-8";
    Ответ.УстановитьТелоИзСтроки(ДанныеСервиса, КодировкаТекста.UTF8,ИспользованиеByteOrderMark.НеИспользовать);
	Возврат Ответ;	
	
КонецФункции

Функция ПолучитьДанныеСервиса(КодОшибки, Отказ) 

	ЗаписьXML = С_ФормированиеXMLСервер.ПолучитьЗаписьXML();
	ЗаписьXML.ЗаписатьТекст("Succes");
	ЗаписьXML.ЗаписатьКонецЭлемента();

	Возврат  ЗаписьXML.Закрыть();	 
КонецФункции