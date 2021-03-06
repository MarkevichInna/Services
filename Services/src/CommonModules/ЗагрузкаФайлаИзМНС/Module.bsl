
Процедура ЗагрузкаФайлаИзМНС() Экспорт
	
	ДатаФайлаН = Константы.С_ДатаЗагрузкиФайлаМНС.Получить();
	СтараяДата = ДатаФайлаН;
	ДатаФайлаК = ТекущаяДата();
	ВременныйФайл = ПолучитьИмяВременногоФайла("xls");
	Файл = Неопределено;
	Пока ДатаФайлаН < ДатаФайлаК цикл
		Попытка                
			ФайлНаВебСервере = "http://nalog.gov.by/uploads/documents/LIKV_BDOLG" + Лев(ДатаФайлаН,10) + ".xls";
			ПараметрыПолучения	 = Новый Структура("ПутьДляСохранения", ВременныйФайл);
			РезультатИзИнтернета = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(ФайлНаВебСервере, ПараметрыПолучения);
			Если НЕ РезультатИзИнтернета.Свойство("СообщениеОбОшибке") И Не СтараяДата = ДатаФайлаН Тогда
				Файл = ВременныйФайл; 
				Константы.С_ДатаЗагрузкиФайлаМНС.Установить(ДатаФайлаН);
			КонецЕсли;
		Исключение	
		КонецПопытки;	
		ДатаФайлаН = ДатаФайлаН + 60 * 60 * 24;	
	КонецЦикла;
	
	Если Файл = Неопределено  Тогда 
		Возврат;
	КонецЕсли;
	
	УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
	ПараметрыПисьма = Новый Структура;
	
	МассивКому   = Новый Массив;
	СтруктураКому = Новый Структура;
	СтруктураКому.Вставить("Адрес","inna.scorpio@gmail.com");  
	СтруктураКому.Вставить("Представление","inna.scorpio@gmail.com");
	МассивКому.Добавить(СтруктураКому);
	
	СтруктураКому = Новый Структура;
	СтруктураКому.Вставить("Адрес","savo@1c-minsk.by");  
	СтруктураКому.Вставить("Представление","savo@1c-minsk.by");
	МассивКому.Добавить(СтруктураКому);
	ПараметрыПисьма.Вставить("Кому", МассивКому); 
	
	Попытка
		ПараметрыПисьма.Вставить("Тема", "Пришел файл МНС от " + Строка(Константы.С_ДатаЗагрузкиФайлаМНС.Получить())); 
		Вложения = Новый Структура;
		Вложения.Вставить("Файл", Файл);
		ПараметрыПисьма.Вставить("Вложения", Вложения);
		ИдентификаторСообщения = РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма);		
	Исключение    
		ПараметрыПисьма.Вставить("Тема", "Не удалось загрузить файл с сайта МНС " + ОписаниеОшибки()); 
		ИдентификаторСообщения = РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма);
	конецПопытки;
	
КонецПроцедуры

