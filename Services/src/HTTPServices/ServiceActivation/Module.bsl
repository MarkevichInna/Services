
Функция ActivationPOST(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);	
	сч = 0;
	Отказ = Ложь;	
	ОписаниеОшибки = ""; 
	СтруктураПараметров = Неопределено;
	
	ЗаписьXML  = С_ИТССервисыСлужебныеПроцедурыФункции.ПолучитьЗаписьXML();
	ТелоЗапроса = Запрос.ПолучитьТелоКакСтроку(Кодировкатекста.UTF8);
	С_ИТССервисыСлужебныеПроцедурыФункции.ОбработатьВхПараметры(Запрос, ЗаписьXML, СтруктураПараметров, Отказ);
	СтруктураПараметров.Вставить("ТелоЗапроса",ТелоЗапроса);

	Если  Отказ Тогда
		С_ИТССервисыСлужебныеПроцедурыФункции.ДополнитьОписаниеОшибки(ЗаписьXML, "110", "Ошибка активации сервиса",  "Неверно установлены параметры");
		С_ИТССервисыСлужебныеПроцедурыФункции.ДобавитьЭлементXML(ЗаписьXML, "Idrequest", СтруктураПараметров.IDREQUEST);
		ЗаписьXML.ЗаписатьНачалоЭлемента("Service");
		ЗаписьXML.ЗаписатьКонецЭлемента();
	Иначе	
		
		//Если НЕ ЗначениеЗаполнено(СтруктураПараметров.IDSERVICEVA) Тогда
		//	Отказ  = Истина;
		//	ТекстПодставновки = "Не установлен параметр ""Имя сервиса""";	
		//	ОписаниеОшибки = ?(ОписаниеОшибки = "", текстПодставновки, СокрЛП(ОписаниеОшибки) + Символы.ВК + ТекстПодставновки);				
		//КонецЕсли;

		REGNUMBERS = С_ИТССервисыСлужебныеПроцедурыФункции.РазложитьСтрокуВМассивПодстрок(СтруктураПараметров.REGNUMBERS, ";");
		INN = С_ИТССервисыСлужебныеПроцедурыФункции.РазложитьСтрокуВМассивПодстрок(СтруктураПараметров.INN, ";");
		NAMECUSTOMER = С_ИТССервисыСлужебныеПроцедурыФункции.РазложитьСтрокуВМассивПодстрок(СтруктураПараметров.NAMECUSTOMER, ";");
		SERVICE = С_ИТССервисыСлужебныеПроцедурыФункции.РазложитьСтрокуВМассивПодстрок(СтруктураПараметров.IDSERVICEVA, ";");
		
		Если REGNUMBERS.Количество() = 0  Тогда
			Отказ = Истина;
			ТекстПодставновки = "Не установлен параметр ""Рег. номер(а)""";
			ОписаниеОшибки = ?(ОписаниеОшибки = "", текстПодставновки, СокрЛП(ОписаниеОшибки) + Символы.ВК + ТекстПодставновки);				
		КонецЕсли;
		
		Если INN.Количество() = 0 Тогда
			Отказ  = Истина;
			текстПодставновки = "Не установлен параметр ""УНП""";	
			ОписаниеОшибки = ?(ОписаниеОшибки = "", текстПодставновки, СокрЛП(ОписаниеОшибки) + Символы.ВК + ТекстПодставновки);				
		КонецЕсли;
		
		С_ИТССервисыСлужебныеПроцедурыФункции.ДобавитьЭлементXML(ЗаписьXML, "Idrequest", СтруктураПараметров.IDREQUEST);
		ЗаписьXML.ЗаписатьНачалоЭлемента("Service");
		
		Если Не Отказ Тогда
			Для каждого РегНомер ИЗ REGNUMBERS Цикл
				сч = 0;
				Для каждого УНП ИЗ INN Цикл	
					Если  NAMECUSTOMER.Количество() = 0 Тогда
						НазваниеОрганизации = "";
					Иначе	 
						Попытка
							НазваниеОрганизации = NAMECUSTOMER[сч];
						Исключение
							НазваниеОрганизации = NAMECUSTOMER[0];	
						КонецПопытки;
					КонецЕсли;	
					Отказ = Ложь;
					//С_ИТССервер.ПроверитьПодпискуИТС(СтруктураПараметров, КодОшибки, Отказ);						
					Если Отказ Тогда				
						ТекстПодставновки = "Отсутствует ИТС для рег. номера """ + РегНомер + """ и УНП """ + унп + """";				
						ОписаниеОшибки = ?(ОписаниеОшибки = "", текстПодставновки, СокрЛП(ОписаниеОшибки) + Символы.ВК + ТекстПодставновки);
					Иначе
						ПользовательСервиса = С_ИТСМеждународныйСервер.ПолучитьПользователяСервисов(РегНомер, УНП, НазваниеОрганизации);
						Если  ПользовательСервиса = Неопределено Тогда
							Отказ = Истина;
							ТекстПодставновки = "Не создан пользователь сервисов для рег. номера """ + РегНомер + """ и УНП """ + унп + """";				
							ОписаниеОшибки = ?(ОписаниеОшибки = "", текстПодставновки, СокрЛП(ОписаниеОшибки) + Символы.ВК + ТекстПодставновки);
						Иначе							
							Попытка
								Для каждого сервис ИЗ SERVICE Цикл
									Сервис = Справочники.С_Сервисы[сервис];
									С_ИТСМеждународныйСервер.ДобавитьСервис(ПользовательСервиса, Сервис, СтруктураПараметров, Отказ);
									Если Отказ Тогда
										ТекстПодставновки = "Ошибка добавления сервиса для рег. номера """ + РегНомер + """ и УНП """ + унп + """";				
										ОписаниеОшибки = ?(ОписаниеОшибки = "", текстПодставновки, СокрЛП(ОписаниеОшибки) + Символы.ВК + ТекстПодставновки);
									Иначе
										ЗаписьXML.ЗаписатьНачалоЭлемента("Items");
											ЗаписьXML.ЗаписатьАтрибут("Idservice", СтруктураПараметров.IDSERVICE);
											ЗаписьXML.ЗаписатьАтрибут("Status",Строка(СтруктураПараметров.STATUS));
											ЗаписьXML.ЗаписатьАтрибут("Unp",Строка(УНП));
											ЗаписьXML.ЗаписатьАтрибут("Idserviceva", Сервис.ИмяПредопределенныхДанных);
											ЗаписьXML.ЗаписатьАтрибут("Regnumbers",Строка(РегНомер));
										ЗаписьXML.ЗаписатьКонецЭлемента();				
									КонецЕсли;	
								КонецЦикла;
							Исключение
								Отказ = Истина;
								ТекстПодставновки = "Ошибка добавления сервиса для рег. номера """ + РегНомер + """ и УНП """ + унп + """";				
								ОписаниеОшибки = ?(ОписаниеОшибки = "", текстПодставновки, СокрЛП(ОписаниеОшибки) + Символы.ВК + ТекстПодставновки);
								//ИТССервисыСлужебныеПроцедурыФункции.ОтослатьПисьмо("ActivationPOST", ТелоЗапроса, ОписаниеОшибки());
							КонецПопытки;	
						КонецЕсли;			
					КонецЕсли;
					сч = сч + 1;
				КонецЦикла;	
			КонецЦикла;
		КонецЕсли;	
		
		ЗаписьXML.ЗаписатьКонецЭлемента(); // сервис
		Если Отказ  Тогда
			ЗаписьXML.ЗаписатьНачалоЭлемента("Error");
				ЗаписьXML.ЗаписатьНачалоЭлемента("Code");
				ЗаписьXML.ЗаписатьТекст("110"); 
				ЗаписьXML.ЗаписатьКонецЭлемента();
			
				ЗаписьXML.ЗаписатьНачалоЭлемента("Head");
				ЗаписьXML.ЗаписатьТекст("Ошибка активации сервиса"); 
				ЗаписьXML.ЗаписатьКонецЭлемента();
			
				ЗаписьXML.ЗаписатьНачалоЭлемента("Description");
				ЗаписьXML.ЗаписатьТекст(ОписаниеОшибки); 
				ЗаписьXML.ЗаписатьКонецЭлемента();
			ЗаписьXML.ЗаписатьКонецЭлемента();
		Иначе
			ЗаписьXML.ЗаписатьНачалоЭлемента("Error");
			ЗаписьXML.ЗаписатьКонецЭлемента();		
		КонецЕсли;	
	КонецЕсли;
	ЗаписьXML.ЗаписатьКонецЭлемента();  //result
	СтрокаДляОтвета = ЗаписьXML.Закрыть();	
	Ответ.Заголовки["Content-Type"] =  "text/xml;charset=UTF-8";
	Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	С_ИТССервисыСлужебныеПроцедурыФункции.ОтослатьПисьмо("ActivationPOST", ТелоЗапроса, СтрокаДляОтвета, "Результат");

	Возврат Ответ;
	
КонецФункции
	
