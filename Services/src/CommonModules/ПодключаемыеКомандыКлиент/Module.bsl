////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность" (клиент).
// Обслуживает подключаемые команды.
// Выполняется на клиенте.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик команды формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма, из которой выполняется команда.
//   Команда - КомандаФормы - Выполняемая команда.
//   Источник - ТаблицаФормы, ДанныеФормыСтруктура - Объект или список формы с полем "Ссылка".
//
Процедура ВыполнитьКоманду(Форма, Команда, Источник) Экспорт
	ИмяКоманды = Команда.Имя;
	АдресНастроек = Форма.Команды.Найти("АдресНастроекКомандВоВременномХранилище").Действие;
	ОписаниеКоманды = ПодключаемыеКомандыКлиентПовтИсп.ОписаниеКоманды(ИмяКоманды, АдресНастроек);
	
	Контекст = ПараметрыВыполненияКоманды();
	Контекст.ОписаниеКоманды = Новый Структура(ОписаниеКоманды);
	Контекст.Форма = Форма;
	Если Не Контекст.ЭтоФормаОбъекта И ЗначениеЗаполнено(ОписаниеКоманды.ИмяСписка) Тогда
		Источник = Форма.Элементы.Найти(ОписаниеКоманды.ИмяСписка);
	КонецЕсли;
	Контекст.Источник = Источник;
	Контекст.ЭтоФормаОбъекта  = ТипЗнч(Источник) = Тип("ДанныеФормыСтруктура");
	Контекст.Вставить("ТребуетсяОпределитьСсылки", Истина);
	Контекст.Вставить("ТребуетсяЗапись", Контекст.ЭтоФормаОбъекта И ОписаниеКоманды.РежимЗаписи <> "НеЗаписывать");
	Контекст.Вставить("ТребуетсяПроведение", ОписаниеКоманды.РежимЗаписи = "Проводить");
	Контекст.Вставить("ТребуетсяРаботаСФайлами", ОписаниеКоманды.ТребуетсяРаботаСФайлами И Не ПодключитьРасширениеРаботыСФайлами());
	
	ПродолжитьВыполнениеКоманды(Контекст);
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Шаблоны.

// Шаблон второго параметра обработчика команды.
//
// Возвращаемое значение:
//   Структура - Вспомогательные параметры.
//       * ОписаниеКоманды - Структура - Описание команды.
//           Структура аналогична таблице ПодключаемыеКоманды.ТаблицаКоманд().
//           ** Идентификатор - Строка - Идентификатор команды.
//           ** Представление - Строка - Представление команды в форме.
//           ** ДополнительныеПараметры - Неопределено, ФиксированнаяСтруктура - Дополнительные параметры команды.
//       * Форма - УправляемаяФорма - Форма, из которой вызвана команда.
//       * ЭтоФормаОбъекта - Булево - Истина, если команда вызвана из формы объекта.
//       * Источник - ТаблицаФормы, ДанныеФормыСтруктура - Объект или список формы с полем "Ссылка".
//
Функция ПараметрыВыполненияКоманды()
	Структура = Новый Структура("ОписаниеКоманды, Форма, Источник");
	Структура.Вставить("ЭтоФормаОбъекта", Ложь);
	Возврат Структура;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет команду, подключенную к форме.
Процедура ПродолжитьВыполнениеКоманды(Контекст)
	Источник = Контекст.Источник;
	ОписаниеКоманды = Контекст.ОписаниеКоманды;
	
	// Установка расширения работы с файлами.
	Если Контекст.ТребуетсяРаботаСФайлами Тогда
		Контекст.ТребуетсяРаботаСФайлами = Ложь;
		Обработчик = Новый ОписаниеОповещения("ПродолжитьВыполнениеКомандыПослеУстановкиРасширенияРаботыСФайлами", ЭтотОбъект, Контекст);
		ТекстСообщения = НСтр("ru = 'Для продолжения необходимо установить расширение для веб-клиента 1С:Предприятие.'");
		ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик, ТекстСообщения, Ложь);
		Возврат;
	КонецЕсли;
	
	// Запись в форме объекта.
	Если Контекст.ТребуетсяЗапись Тогда
		Контекст.ТребуетсяЗапись = Ложь;
		Если Источник.Ссылка.Пустая()
			Или (ОписаниеКоманды.РежимЗаписи <> "ЗаписыватьТолькоНовые" И Контекст.Форма.Модифицированность) Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Данные еще не записаны.
					|Выполнение действия ""%1"" возможно только после записи данных.
					|Данные будут записаны.'"),
				ОписаниеКоманды.Представление);
			Обработчик = Новый ОписаниеОповещения("ПродолжитьВыполнениеКомандыПослеПодтверждениеЗаписи", ЭтотОбъект, Контекст);
			ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// Определение ссылок объектов.
	Если Контекст.ТребуетсяОпределитьСсылки Тогда
		Контекст.ТребуетсяОпределитьСсылки = Ложь;
		МассивСсылок = Новый Массив;
		Если Контекст.ЭтоФормаОбъекта Тогда
			ДобавитьСсылкуВСписок(Источник, МассивСсылок, ОписаниеКоманды.ТипПараметра);
		ИначеЕсли Не ОписаниеКоманды.МножественныйВыбор Тогда
			ДобавитьСсылкуВСписок(Источник.ТекущиеДанные, МассивСсылок, ОписаниеКоманды.ТипПараметра);
		Иначе
			Для Каждого Идентификатор Из Источник.ВыделенныеСтроки Цикл
				ДобавитьСсылкуВСписок(Источник.ДанныеСтроки(Идентификатор), МассивСсылок, ОписаниеКоманды.ТипПараметра);
			КонецЦикла;
		КонецЕсли;
		Если МассивСсылок.Количество() = 0 И ОписаниеКоманды.РежимЗаписи <> "НеЗаписывать" Тогда
			ВызватьИсключение НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'");
		КонецЕсли;
		Контекст.Вставить("МассивСсылок", МассивСсылок);
	КонецЕсли;
	
	// Проведение документов.
	Если Контекст.ТребуетсяПроведение Тогда
		Контекст.ТребуетсяПроведение = Ложь;
		ИнформацияОДокументах = ПодключаемыеКомандыВызовСервера.ИнформацияОДокументах(Контекст.МассивСсылок);
		Если ИнформацияОДокументах.КоличествоНеПроведенных > 0 Тогда
			Если ИнформацияОДокументах.ЕстьПравоПроведенияХотяБыОдногоНепроведенного Тогда
				Если ИнформацияОДокументах.КоличествоНеПроведенных = 1 Тогда
					ТекстВопроса = НСтр("ru = 'Для выполнения команды необходимо предварительно провести документ. Выполнить проведение документа и продолжить?'");
				Иначе
					ТекстВопроса = НСтр("ru = 'Для выполнения команды необходимо предварительно провести документы. Выполнить проведение документов и продолжить?'");
				КонецЕсли;
				Контекст.Вставить("НепроведенныеДокументы", ИнформацияОДокументах.НеПроведенные);
				Обработчик = Новый ОписаниеОповещения("ПродолжитьВыполнениеКомандыПослеПодтверждениеПроведения", ЭтотОбъект, Контекст);
				ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
			Иначе
				Если ИнформацияОДокументах.КоличествоНеПроведенных = 1 Тогда
					ТекстПредупреждения = НСтр("ru = 'Для выполнения команды необходимо предварительно провести документ. Недостаточно прав для проведения документа.'");
				Иначе
					ТекстПредупреждения = НСтр("ru = 'Для выполнения команды необходимо предварительно провести документы. Недостаточно прав для проведения документов.'");
				КонецЕсли;
				ПоказатьПредупреждение(, ТекстПредупреждения);
			КонецЕсли;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// Выполнение команды.
	Если ОписаниеКоманды.МножественныйВыбор Тогда
		ПараметрКоманды = Контекст.МассивСсылок;
	ИначеЕсли Контекст.МассивСсылок.Количество() = 0 Тогда
		ПараметрКоманды = Неопределено;
	Иначе
		ПараметрКоманды = Контекст.МассивСсылок[0];
	КонецЕсли;
	Если ОписаниеКоманды.Серверная Тогда
		СерверныйКонтекст = Новый Структура;
		СерверныйКонтекст.Вставить("ПараметрКоманды", ПараметрКоманды);
		СерверныйКонтекст.Вставить("ИмяКомандыВФорме", ОписаниеКоманды.ИмяВФорме);
		Результат = Новый Структура;
		Контекст.Форма.Подключаемый_ВыполнитьКомандуНаСервере(СерверныйКонтекст, Результат);
		Если ЗначениеЗаполнено(Результат.Текст) Тогда
			ПараметрыПредупреждения = Новый Структура("Текст, Подробно");
			ПараметрыПредупреждения.Текст    = Результат.Текст;
			ПараметрыПредупреждения.Подробно = Результат.Подробно;
			СтандартныеПодсистемыКлиент.ВывестиПредупреждение(Контекст.Форма, ПараметрыПредупреждения);
		Иначе
			ОбновитьФорму(Контекст);
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(ОписаниеКоманды.Обработчик) Тогда
			МассивПодстрок = СтрРазделить(ОписаниеКоманды.Обработчик, ".");
			Если МассивПодстрок.Количество() = 1 Тогда
				КлиентскийМодуль = ПолучитьФорму(ОписаниеКоманды.ИмяФормы, ПараметрыФормы(Контекст, ПараметрКоманды), Контекст.Форма, Истина);
				ИмяПроцедуры = ОписаниеКоманды.Обработчик;
			Иначе
				КлиентскийМодуль = ОбщегоНазначенияКлиент.ОбщийМодуль(МассивПодстрок[0]);
				ИмяПроцедуры = МассивПодстрок[1];
			КонецЕсли;
			Обработчик = Новый ОписаниеОповещения(ИмяПроцедуры, КлиентскийМодуль, Контекст);
			ВыполнитьОбработкуОповещения(Обработчик, ПараметрКоманды);
		ИначеЕсли ЗначениеЗаполнено(ОписаниеКоманды.ИмяФормы) Тогда
			ОткрытьФорму(ОписаниеКоманды.ИмяФормы, ПараметрыФормы(Контекст, ПараметрКоманды), Контекст.Форма, Истина);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Ветка процедуры, возникающая после диалога подтверждения записи.
Процедура ПродолжитьВыполнениеКомандыПослеПодтверждениеЗаписи(Ответ, Контекст) Экспорт
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ОчиститьСообщения();
		Контекст.Форма.Записать();
		Если Контекст.Источник.Ссылка.Пустая() Или Контекст.Форма.Модифицированность Тогда
			Возврат; // Запись не удалась, сообщения о причинах выводит платформа.
		КонецЕсли;
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	ПродолжитьВыполнениеКоманды(Контекст)
КонецПроцедуры

// Ветка процедуры, возникающая после диалога подтверждения проведения.
Процедура ПродолжитьВыполнениеКомандыПослеПодтверждениеПроведения(Ответ, Контекст) Экспорт
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	ДанныеОНепроведенныхДокументах = ОбщегоНазначенияВызовСервера.ПровестиДокументы(Контекст.НепроведенныеДокументы);
	ШаблонСообщения = НСтр("ru = 'Документ %1 не проведен: %2'");
	НепроведенныеДокументы = Новый Массив;
	Для Каждого ИнформацияОДокументе Из ДанныеОНепроведенныхДокументах Цикл
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонСообщения,
				Строка(ИнформацияОДокументе.Ссылка),
				ИнформацияОДокументе.ОписаниеОшибки),
				ИнформацияОДокументе.Ссылка);
		НепроведенныеДокументы.Добавить(ИнформацияОДокументе.Ссылка);
	КонецЦикла;
	Контекст.Вставить("НепроведенныеДокументы", НепроведенныеДокументы);
	
	Контекст.МассивСсылок = ОбщегоНазначенияКлиентСервер.СократитьМассив(Контекст.МассивСсылок, НепроведенныеДокументы);
	
	// Оповещаем открытые формы о том, что были проведены документы.
	ТипыПроведенныхДокументов = Новый Соответствие;
	Для Каждого ПроведенныйДокумент Из Контекст.МассивСсылок Цикл
		ТипыПроведенныхДокументов.Вставить(ТипЗнч(ПроведенныйДокумент));
	КонецЦикла;
	Для Каждого Тип Из ТипыПроведенныхДокументов Цикл
		ОповеститьОбИзменении(Тип.Ключ);
	КонецЦикла;
	
	// Если команда была вызвана из формы, то зачитываем в форму актуальную (проведенную) копию из базы.
	Если ТипЗнч(Контекст.Форма) = Тип("УправляемаяФорма") Тогда
		Если Контекст.ЭтоФормаОбъекта Тогда
			Контекст.Форма.Прочитать();
		КонецЕсли;
		Контекст.ОбновитьОтображениеДанных();
	КонецЕсли;
	
	Если НепроведенныеДокументы.Количество() > 0 Тогда
		// Спрашиваем пользователя о необходимости продолжения создания на основании при наличии непроведенных документов.
		ТекстДиалога = НСтр("ru = 'Не удалось провести один или несколько документов.'");
		
		КнопкиДиалога = Новый СписокЗначений;
		Если Контекст.МассивСсылок.Количество() = 0 Тогда
			КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'ОК'"));
		Иначе
			ТекстДиалога = ТекстДиалога + " " + НСтр("ru = 'Продолжить?'");
			КнопкиДиалога.Добавить(КодВозвратаДиалога.Пропустить, НСтр("ru = 'Продолжить'"));
			КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена);
		КонецЕсли;
		
		Обработчик = Новый ОписаниеОповещения("ПродолжитьВыполнениеКомандыПослеПодтверждениеПродолжения", ЭтотОбъект, Контекст);
		ПоказатьВопрос(Обработчик, ТекстДиалога, КнопкиДиалога);
		Возврат;
	КонецЕсли;
	
	ПродолжитьВыполнениеКоманды(Контекст);
КонецПроцедуры

// Ветка процедуры, возникающая после диалога подтверждения продолжения когда есть непроведенные документы.
Процедура ПродолжитьВыполнениеКомандыПослеПодтверждениеПродолжения(Ответ, Контекст) Экспорт
	Если Ответ <> КодВозвратаДиалога.Пропустить Тогда
		Возврат;
	КонецЕсли;
	ПродолжитьВыполнениеКоманды(Контекст);
КонецПроцедуры

// Ветка процедуры, возникающая после установки расширения работы с файлами.
Процедура ПродолжитьВыполнениеКомандыПослеУстановкиРасширенияРаботыСФайлами(РасширениеРаботыСФайламиПодключено, Контекст) Экспорт
	Если Не ПодключитьРасширениеРаботыСФайлами() Тогда
		Возврат;
	КонецЕсли;
	ПродолжитьВыполнениеКоманды(Контекст);
КонецПроцедуры

// Получает ссылку из строки таблицы, проверяет что ссылка соответствует типу и добавляет в массив.
Процедура ДобавитьСсылкуВСписок(ДанныеФормыСтруктура, МассивСсылок, ТипПараметра)
	Ссылка = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеФормыСтруктура, "Ссылка");
	Если ТипПараметра <> Неопределено И Не ТипПараметра.СодержитТип(ТипЗнч(Ссылка)) Тогда
		Возврат;
	ИначеЕсли Ссылка = Неопределено Или ТипЗнч(Ссылка) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	МассивСсылок.Добавить(Ссылка);
КонецПроцедуры

// Формирует параметры формы подключенного объекта в контексте выполняемой команды.
Функция ПараметрыФормы(Контекст, ПараметрКоманды)
	Результат = Контекст.ОписаниеКоманды.ПараметрыФормы;
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Результат = Новый Структура;
	КонецЕсли;
	Контекст.ОписаниеКоманды.Удалить("ПараметрыФормы");
	Результат.Вставить("ОписаниеКоманды", Контекст.ОписаниеКоманды);
	Результат.Вставить("ПараметрКоманды", ПараметрКоманды);
	Возврат Результат;
КонецФункции

// Обновляет форму целевого объекта после окончания выполнения команды.
Процедура ОбновитьФорму(Контекст)
	Если Контекст.ЭтоФормаОбъекта И Контекст.ОписаниеКоманды.РежимЗаписи <> "НеЗаписывать" И Не Контекст.Форма.Модифицированность Тогда
		Попытка
			Контекст.Форма.Прочитать();
		Исключение
			// Если метода Прочитать нет, значит печать выполнена не из формы объекта.
		КонецПопытки;
	КонецЕсли;
	Если Контекст.ОписаниеКоманды.РежимЗаписи <> "НеЗаписывать" Тогда
		ТипыИзмененныхОбъектов = Новый Массив;
		Для Каждого Ссылка Из Контекст.МассивСсылок Цикл
			Тип = ТипЗнч(Ссылка);
			Если ТипыИзмененныхОбъектов.Найти(Ссылка) = Неопределено Тогда
				ТипыИзмененныхОбъектов.Добавить(Ссылка);
			КонецЕсли;
		КонецЦикла;
		Для Каждого Тип Из ТипыИзмененныхОбъектов Цикл
			ОповеститьОбИзменении(Тип);
		КонецЦикла;
	КонецЕсли;
	Контекст.Форма.ОбновитьОтображениеДанных();
КонецПроцедуры

#КонецОбласти
