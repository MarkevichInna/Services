
Функция POSTRequest(Запрос)
	
	Отказ = Ложь;
	КодОшибки = "";
	Ответ = Новый HTTPСервисОтвет(200);		
	
	СтруктураПараметров = С_СлужебныеПроцедурыФункцииСервер.РазобратьВходныеданные(Запрос);		
	С_РаботаССервисамиСлужебный.ПроверитьОбщийДоступКСервисам(СтруктураПараметров,  Ответ, КодОшибки, Отказ);

	Если Отказ Тогда
		Возврат Ответ
	КонецЕсли;
	
	С_РаботаССервисамиСлужебный.ЗарегистрироватьИспользованиеСервиса(СтруктураПараметров, Справочники.С_Сервисы.CurrClassifier, КодОшибки, Отказ);
	
	Если Отказ Тогда
		С_СлужебныеПроцедурыФункцииСервер.УстановитьКодОшибки(Ответ, КодОшибки);
		Возврат Ответ
	КонецЕсли;
									
	ДвоичныеДанные = ПолучитьДанныеСервиса(КодОшибки, Отказ);	
	Если Отказ Тогда
		С_СлужебныеПроцедурыФункцииСервер.УстановитьКодОшибки(Ответ, КодОшибки);
		Возврат Ответ; 
	КонецЕсли;	
	
	Ответ.УстановитьТелоИзДвоичныхДанных(ДвоичныеДанные);
								
	Возврат Ответ;	
КонецФункции

Функция ПолучитьДанныеСервиса(КодОшибки, Отказ)
	
	ДвоичныеДанные = Неопределено;
	Попытка
		ТекстМакета = Справочники.С_КлассификаторБанков.КлассификаторБанков.Текст;
		ВременныйФайл = ПолучитьИмяВременногоФайла();
		Запись = Новый ЗаписьТекста();
		Запись.Открыть(ВременныйФайл);
		Запись.Записать(ТекстМакета);
		Запись.Закрыть();
		ДвоичныеДанные = Новый ДвоичныеДанные(ВременныйФайл);
		УдалитьФайлы(ВременныйФайл);
	Исключение	
		КодОшибки = "BANKS_CLASSIFIER_ERROR";
		Отказ = Истина;
	КонецПопытки;	
	
	Возврат Двоичныеданные
КонецФункции	
