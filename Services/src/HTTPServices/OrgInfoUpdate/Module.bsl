
Функция OrgInfoPOST(Запрос)
	
	Отказ = Ложь;
	КодОшибки = "";
	Ответ = Новый HTTPСервисОтвет(200);	
	
	ТелоЗапроса = Запрос.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	СтруктураПараметров = С_СлужебныеПроцедурыФункцииСервер.РазобратьВходныеданные(Запрос);
	ПозицияXML = Найти(ТелоЗапроса, "<?xml");
	
	ТелоXML = Сред(ТелоЗапроса, ПозицияXML, СтрДлина(ТелоЗапроса)-1);
	
	С_РаботаССервисамиСлужебный.ПроверитьОбщийДоступКСервисам(СтруктураПараметров,  Ответ, КодОшибки, Отказ);

	Если Отказ Тогда
		Возврат Ответ
	КонецЕсли;
	
	С_РаботаССервисамиСлужебный.ЗарегистрироватьИспользованиеСервиса(СтруктураПараметров, Справочники.С_Сервисы.OrgInfo, КодОшибки, Отказ);
	
	Если Отказ Тогда
		С_СлужебныеПроцедурыФункцииСервер.УстановитьКодОшибки(Ответ, КодОшибки);
		Возврат Ответ
	КонецЕсли;
									
	ОбновитьДанныеСервиса(ТелоXML, КодОшибки, Отказ);
	
	Если Отказ Тогда
		С_СлужебныеПроцедурыФункцииСервер.УстановитьКодОшибки(Ответ, КодОшибки);
		Возврат Ответ; 
	КонецЕсли;	

	Возврат Ответ;

КонецФункции

Процедура ОбновитьДанныеСервиса(ТелоXML, КодОшибки, Отказ)

	Попытка	 
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(ТелоXML);
		ДанныеКонтрагентаXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);	
		С_СвободныйРеестрСервер.ОбработатьОрганизацию(ДанныеКонтрагентаXDTO, КодОшибки, Отказ);
	Исключение
		Отказ = Истина;
		КодОшибки = "ERROR_ORGINFOREAD";
		Возврат;
	КонецПопытки;
	
	ЧтениеXML.Закрыть();
	
КонецПроцедуры	