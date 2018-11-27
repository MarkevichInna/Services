
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	//Данные = ЗагруженныеРегионы();
	//ОписаниеЗагруженныхОбъектов = Данные.Заголовок;
	//Элементы.ПроверитьОбновлениеАдресногоКлассификатора.Доступность = Данные.КоличествоЗагруженных>0;    
	//Элементы.ОчиститьАдресныйКлассификатор.Доступность = Элементы.ПроверитьОбновлениеАдресногоКлассификатора.Доступность;
	//
	//УправлениеФормамиУТВызовСервера_Локализация.ПриСозданииНаСервере(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗагруженАдресныйКлассификатор" Или ИмяСобытия = "ОчищенАдресныйКлассификатор" Тогда
		Данные = ЗагруженныеРегионы();
		ОписаниеЗагруженныхОбъектов = Данные.Заголовок;
		Элементы.ПроверитьОбновлениеАдресногоКлассификатора.Доступность = Данные.КоличествоЗагруженных > 0;
		Элементы.ОчиститьАдресныйКлассификатор.Доступность = Элементы.ПроверитьОбновлениеАдресногоКлассификатора.Доступность;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьАдресныйКлассификатор(Команда)
	
	С_АдресныйКлассификаторКлиент.ЗагрузитьАдресныйКлассификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьАдресныйКлассификатор(Команда)
	
	С_АдресныйКлассификаторКлиент.ОчиститьКлассификатор(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьОбновлениеАдресногоКлассификатора(Команда)
	
	С_АдресныйКлассификаторКлиент.ОпределитьНеобходимостьОбновленияАдресныхОбъектов(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗагруженныеРегионы()
	
	Результат = Новый Структура("Заголовок, КоличествоЗагруженных",
		НСтр("ru = 'Адресный классификатор не заполнен.'"), С_АдресныйКлассификаторСервер.ЧислоЗаполненныхАдресныхОбъектов());
	
	Если Результат.КоличествоЗагруженных > 0 Тогда
		Результат.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Загружено регионов: %1.'"), Результат.КоличествоЗагруженных);
			
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти
