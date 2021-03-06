
//Процедура для программного управления реквизитами форм при локализации
//Параметры:
//Форма - управляемая форма, для которой вызывается процедура,
Процедура ПриСозданииНаСервере(Форма) Экспорт

	Имя = Форма.ИмяФормы;
	
	Если Имя = "РегистрСведений.С_АдресныйКлассификатор.Форма.С_АдресныйКлассификатор" Тогда
		ПриСозданииФормыАдресныйКлассификатор(Форма);
	ИначеЕсли Имя = "РегистрСведений.С_АдресныйКлассификатор.Форма.ЗагрузкаАдресногоКлассификатора" Тогда
		ПриСозданииФормыЗагрузкаАдресногоКлассификатора(Форма);
	ИначеЕсли Имя = "РегистрСведений.С_АдресныйКлассификатор.Форма.ОчисткаАдресногоКлассификатора" Тогда
		ПриСозданииФормыОчисткаАдресногоКлассификатора(Форма);
	КонецЕсли;
	
КонецПроцедуры 

//регистры
Процедура ПриСозданииФормыАдресныйКлассификатор(Форма)

	Элементы = Форма.Элементы;
	
	Элементы.ПроверитьОбновлениеАдресногоКлассификатора.Видимость = Ложь;
    Элементы.ЗагрузитьАдресныйКлассификаторРасширеннаяПодсказка.Заголовок = "Перейти к загрузке адресного классификатора из указанного каталога";	

КонецПроцедуры

Процедура ПриСозданииФормыЗагрузкаАдресногоКлассификатора(Форма) 

	Элементы = Форма.Элементы;
	
    Элементы.ТекстОписанияЗагрузкиРасширеннаяПодсказка.Заголовок ="Внимание: загрузка адресного классификатора может занять длительное время, которое зависит от количества выбранных регионов РБ.";

	
КонецПроцедуры

Процедура ПриСозданииФормыОчисткаАдресногоКлассификатора(Форма) 

	Элементы = Форма.Элементы;
	
    Элементы.ТекстОписанияОчисткиРасширеннаяПодсказка.Заголовок ="Внимание: загрузка адресного классификатора может занять длительное время, которое зависит от количества выбранных регионов РБ.";

	
КонецПроцедуры

