
Функция OrgConfirmCheck(UNP)
	
	Подтвержден = Ложь;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Организации.Подтвержден
		|ИЗ
		|	Справочник.С_Организации КАК Организации
		|ГДЕ
		|	Организации.ИНН = &ИНН";
	
	Запрос.УстановитьПараметр("ИНН", UNP);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		 Подтвержден = Истина;
	КонецЦикла;
	             	
	
	ТипПроверкаПодтверждения = ФабрикаXDTO.Тип("http://www.OrgConfirm", "Confirm");
	ПроверкаПодтверждения = ФабрикаXDTO.Создать(ТипПроверкаПодтверждения);
    ПроверкаПодтверждения.IsConfirm = Подтвержден;
	Возврат  ПроверкаПодтверждения;
	
КонецФункции

