
Функция AddressClassifierUpdateAlert()
	ТипДатаОбновления = ФабрикаXDTO.Тип("http://www.AddressClassifierUpdate", "DateUpdate");
	ДатаОбновления = ФабрикаXDTO.Создать(ТипДатаОбновления);
    ДатаОбновления.Date = Справочники.С_ОбновлениеАдресногоКлассификатора.АдресныйКлассификатор.ДатаАдресногоКлассификатора;
	Возврат  ДатаОбновления;

КонецФункции

