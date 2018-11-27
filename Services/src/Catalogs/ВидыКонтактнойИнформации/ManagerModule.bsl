#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает описание блокируемых реквизитов.
//
// Возвращаемое значение:
//     Массив - содержит строки в формате ИмяРеквизита[;ИмяЭлементаФормы,...]
//              где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы - имя элемента формы, связанного с
//              реквизитом.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("Тип;Тип");
	БлокируемыеРеквизиты.Добавить("Родитель");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов.

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов.
//
// Возвращаемое значение:
//     Массив - содержит строки имен реквизитов.
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("*");
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Процедура обновления ИБ для справочника видов контактной информации.
//
// Инструкция:
// Для каждого объекта, владельца КИ, для каждого соответствующего ему вида КИ добавить 
// строчку вида: ОбновитьВидКИ(.....). При этом,
// важен порядок в котором будут осуществляться эти вызовы, чем раньше вызов для вида КИ,
// тем выше этот вид КИ будет располагаться на форме объекта.
//
// Параметры функции УправлениеКонтактнойИнформацией.ОбновитьВидКИ:
// 1. Вид КИ - Ссылка на предопределенный вид КИ.
// 2. Тип КИ - Ссылка на перечисление
// 3. МожноИзменятьСпособРедактирования  - Определяет, можно ли в режиме Предприятие изменить способ редактирования,
//                                         например, для адресов, которые попадают в регл. отчетность, нужно
//                                         запретить возможность изменения.
// 4. РедактированиеТолькоВДиалоге       - Если установить Истина, то будет значение вида КИ можно будет
//                                         редактировать только в форме ввода (имеет смысл только для
//                                         адресов, телефонов и факсов).
// 5. АдресТолькоРоссийский              - Если установить Истина, то для адресов можно будет ввести 
//                                         только российский адрес (имеет смысл только для адресов).
// 6. Порядок                            - Определяет порядок элемента, для сортировки относительно других
//
//
Процедура ЗаполнитьСвойстваВидовКонтактнойИнформации() Экспорт
	
	// СтандартныеПодсистемы 
	// СтандартныеПодсистемы.Пользователи
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.EmailПользователя,
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты, 	Истина, Ложь, Ложь, 1);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ТелефонПользователя,
		Перечисления.ТипыКонтактнойИнформации.Телефон,               	Истина, Ложь, Ложь, 2);
	// Конец СтандартныеПодсистемы.Пользователи
	
	// СтандартныеПодсистемы.Организации
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации,
		Перечисления.ТипыКонтактнойИнформации.Адрес,                 	Истина, Ложь, Истина, 12);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации,
		Перечисления.ТипыКонтактнойИнформации.Адрес,                 	Истина, Ложь,   Ложь, 13);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации,
		Перечисления.ТипыКонтактнойИнформации.Телефон,               	Истина, Ложь,   Ложь, 14);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ФаксОрганизации,
		Перечисления.ТипыКонтактнойИнформации.Факс,                  	Истина, Ложь,   Ложь, 15);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.EmailОрганизации,
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты, 	Истина, Ложь,   Ложь, 16);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресОрганизации,
		Перечисления.ТипыКонтактнойИнформации.Адрес,                 	Истина, Ложь,   Ложь, 17);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияОрганизации,
		Перечисления.ТипыКонтактнойИнформации.Другое,                	Истина, Ложь,   Ложь, 18);
	// Конец СтандартныеПодсистемы.Организации
	// Конец СтандартныеПодсистемы 
	
	// Справочник "Контрагенты"
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагента,
		Перечисления.ТипыКонтактнойИнформации.Адрес, 					Истина, Ложь, Ложь, 3);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента,
		Перечисления.ТипыКонтактнойИнформации.Адрес, 					Истина, Ложь, Ложь, 4);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресКонтрагента,
		Перечисления.ТипыКонтактнойИнформации.Адрес, 					Истина, Ложь, Ложь, 5);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента,
		Перечисления.ТипыКонтактнойИнформации.Телефон, 					Истина, Ложь, Ложь, 6);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ФаксКонтрагенты,
		Перечисления.ТипыКонтактнойИнформации.Факс, 					Истина, Ложь, Ложь, 7);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.EmailКонтрагента,
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты, 	Истина, Ложь, Ложь, 8);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияКонтрагенты,
		Перечисления.ТипыКонтактнойИнформации.Другое, 					Истина, Ложь, Ложь, 9);
	
	// Справочник "Партнеры"
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.АдресПартнера,
		Перечисления.ТипыКонтактнойИнформации.Адрес,                 	Истина, Ложь, Ложь, 6);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ТелефонПартнера,
		Перечисления.ТипыКонтактнойИнформации.Телефон,               	Истина, Ложь, Ложь, 7);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.EmailПартнера,
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты, 	Истина, Ложь, Ложь, 8);
	
	// Справочник "Контактные лица партнеров"
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ТелефонКонтактногоЛица,
		Перечисления.ТипыКонтактнойИнформации.Телефон,               	Истина, Ложь, Ложь, 9);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.МобильныйТелефонКонтактногоЛица,
		Перечисления.ТипыКонтактнойИнформации.Телефон,               	Истина, Ложь, Ложь, 10);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.EmailКонтактногоЛица,
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты, 	Истина, Ложь, Ложь, 11);
	
	// Справочник "Физические лица"
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.EmailФизическогоЛица,
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,	Истина, Ложь, Ложь, 19);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ТелефонМобильныйФизическиеЛица,
		Перечисления.ТипыКонтактнойИнформации.Телефон,					Истина, Ложь, Ложь, 20);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ТелефонРабочийФизическиеЛица,
		Перечисления.ТипыКонтактнойИнформации.Телефон,					Истина, Ложь, Ложь, 22);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.АдресДляИнформированияФизическиеЛица,
		Перечисления.ТипыКонтактнойИнформации.Адрес,					Истина, Ложь, Ложь, 23);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ТелефонДомашнийФизическиеЛица,
		Перечисления.ТипыКонтактнойИнформации.Телефон,					Истина, Ложь, Ложь, 24);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.АдресЗаПределамиРФФизическиеЛица,
		Перечисления.ТипыКонтактнойИнформации.Адрес,					Истина, Ложь, Ложь, 25);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица,
		Перечисления.ТипыКонтактнойИнформации.Адрес,					Истина, Ложь, Ложь, 26);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица,
		Перечисления.ТипыКонтактнойИнформации.Адрес,					Истина, Ложь, Ложь, 27);
	
	// Справочник "Склады"
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.АдресСклада,
		Перечисления.ТипыКонтактнойИнформации.Адрес,                   	Истина, Ложь, Ложь, 28);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ТелефонСклада,
		Перечисления.ТипыКонтактнойИнформации.Телефон,                 	Истина, Ложь, Ложь, 29);
	
	// Справочник "Регистрации в налоговом органе"
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.АдресНалоговогоОргана,
		Перечисления.ТипыКонтактнойИнформации.Адрес, 					Истина, Ложь, Ложь, 30);
	ОбновитьВидКИ(Справочники.ВидыКонтактнойИнформации.ТелефонНалоговогоОргана,
		Перечисления.ТипыКонтактнойИнформации.Телефон, 					Истина, Ложь, Ложь, 31);
	
КонецПроцедуры

Процедура ОбновитьВидКИ(ВидКИ, Тип, МожноИзменятьСпособРедактирования, РедактированиеТолькоВДиалоге, АдресТолькоРоссийский,	Порядок = Неопределено)

	НастройкиПроверки = Новый Структура;
	НастройкиПроверки.Вставить("АдресТолькоРоссийский", 		АдресТолькоРоссийский);
	НастройкиПроверки.Вставить("ПроверятьКорректность", 		Ложь);
	НастройкиПроверки.Вставить("ЗапрещатьВводНекорректного", 	Ложь);
	НастройкиПроверки.Вставить("СкрыватьНеактуальныеАдреса", 	Ложь);
	НастройкиПроверки.Вставить("ВключатьСтрануВПредставление", 	Ложь);
	
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		ВидКИ,
		Тип,
		"",
		МожноИзменятьСпособРедактирования,
		РедактированиеТолькоВДиалоге,
		Ложь,
		Порядок,
		,
		НастройкиПроверки);	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли