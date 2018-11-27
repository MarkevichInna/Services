////////////////////////////////////////////////////////////////////////////////
// Подсистема "Адресный классификатор".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывает форму загрузки классификатора. Может использоваться как интерфейс.
//
// Параметры:
//     ПараметрыЗагрузки - Структура - параметры, передаваемые в форму при открытии
//
Процедура ЗагрузитьАдресныйКлассификатор(Знач ПараметрыЗагрузки = Неопределено) Экспорт
	
	Если С_АдресныйКлассификаторВызовСервера.МожноИзменятьАдресныйКлассификатор() Тогда
		ОткрытьФорму("РегистрСведений.С_АдресныйКлассификатор.Форма.ЗагрузкаАдресногоКлассификатора", ПараметрыЗагрузки);
	Иначе
		ПоказатьПредупреждение(, НСтр("ru='В разделенном режиме загрузка адресного классификатора не поддерживается.'"));
	КонецЕсли;
	
КонецПроцедуры

// Проверяет наличие обновлений адресного классификатора на сайте
// для тех объектов, которые ранее уже загружались.
//
// Параметры:
//     Владелец - УправляемаяФорма - форма, из которой производится проверка
//
Процедура ОпределитьНеобходимостьОбновленияАдресныхОбъектов(Владелец = Неопределено) Экспорт
	
	Если Не С_АдресныйКлассификаторВызовСервера.МожноИзменятьАдресныйКлассификатор() Тогда
		ПоказатьПредупреждение(, НСтр("ru='В разделенном режиме запрос версии данных адресного классификатора не поддерживается.'"));
		Возврат;
	КонецЕсли;
	
	Если ЗапрашиватьДоступПриИспользовании() Тогда
		// Нужен запрос профиля безопасности
		//РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(
		//	АдресныйКлассификаторВызовСервера_Локализация.ЗапросРазрешенийБезопасностиПроверкиОбновленияКЛАДР(), 
		//	Владелец, 
		//	Новый ОписаниеОповещения("ПолучениеРазрешенияБезопасностиПроверкиНаличияОбновленияАдресныхОбъектов", ЭтотОбъект)
		//);
		//
	Иначе
		// Разрешения уже получены на всю конфигурацию
		Результат = С_АдресныйКлассификаторКлиентСервер.ПроверитьОбновлениеАдресныхОбъектов();
		ОбработкаНеобходимостиОбновленияАдресныхОбъектов(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывает форму очистки сведений адресного классификатора по адресным объектам
//
// Параметры:
//     Владелец - УправляемаяФорма - форма, из которой осуществляется очистка адресного классификатора.
//
Процедура ОчиститьКлассификатор(Владелец = Неопределено) Экспорт
	
	//Если АдресныйКлассификаторВызовСервера_Локализация.МожноИзменятьАдресныйКлассификатор() Тогда
		ОткрытьФорму("РегистрСведений.С_АдресныйКлассификатор.Форма.ОчисткаАдресногоКлассификатора", , Владелец);
	//Иначе
	//	ПоказатьПредупреждение(, НСтр("ru='В разделенном режиме очистка адресного классификатора не поддерживается.'"));
	//КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработка информации о существующем обновлении
//
Процедура ОбработкаНеобходимостиОбновленияАдресныхОбъектов(Знач ДанныеОбновления)
	
	Если Не ДанныеОбновления.Статус Тогда
		ПоказатьПредупреждение(, ДанныеОбновления.СообщениеОбОшибке);
		Возврат;
	КонецЕсли;
	
	Если ДанныеОбновления.Значение.Количество()=0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Адресный классификатор не заполнен.'"));
		Возврат;
	КонецЕсли;
	
	СписокОбновлений = "";
	КоличествоАдресныхОбъектов = 0;
	АдресныеОбъекты  = Новый Массив;
	
	Для Каждого АдресныйОбъект Из ДанныеОбновления.Значение Цикл
		
		Если АдресныйОбъект.КодАдресногоОбъекта <> "AL" И АдресныйОбъект.ОбновлениеДоступно Тогда
			АдресныеОбъекты.Добавить(Лев(АдресныйОбъект.КодАдресногоОбъекта, 2));
			СписокОбновлений = СписокОбновлений + Лев(АдресныйОбъект.КодАдресногоОбъекта, 2)
				+ " - " + АдресныйОбъект.Наименование + " " + АдресныйОбъект.Сокращение + Символы.ПС;
				
			КоличествоАдресныхОбъектов = КоличествоАдресныхОбъектов + 1;
		КонецЕсли;
		
	КонецЦикла;
		
	Если КоличествоАдресныхОбъектов = 0 Тогда
		ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Обновление адресного классификатора не требуется.
			           |В программу уже загружены актуальные адресные сведения от %1.'"),
			Формат(ДанныеОбновления.ВерсияПоследнегоОбновленияКЛАДР, "ДЛФ=D")));
		Возврат;
	КонецЕсли;
	
	// Полный список
	Заголовок = НСтр("ru = 'Обновление адресного классификатора'");
	Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Доступно обновление для регионов (%1):'"), КоличествоАдресныхОбъектов) 
		+ Символы.ПС + СписокОбновлений;
	Оповещение = Новый ОписаниеОповещения("ОпределитьНеобходимостьОбновленияАдресныхОбъектовЗавершение", 
		ЭтотОбъект, АдресныеОбъекты);
		
//	ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
//	ПараметрыВопроса.Заголовок = Заголовок;
//	ПараметрыВопроса.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
//	
//#Если ВебКлиент Тогда
//	// Только информируем окошком, список большой, поэтому используем общую форму, а не предупреждение
//	
//	ПараметрыВопроса.КнопкаПоУмолчанию = КодВозвратаДиалога.ОК;
//	СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(Оповещение, 
//		НСтр("ru = 'Для обновления адресного классификатора требуется запустить программу в тонком клиенте.'")
//		+ Символы.ПС + Символы.ПС + Текст, РежимДиалогаВопрос.ОК, ПараметрыВопроса);
//	Возврат;
//#КонецЕсли

	// Спрашиваем повторно
	//Кнопки = Новый СписокЗначений;
	//Кнопки.Добавить("Да",  НСтр("ru='Обновить'"));
	//Кнопки.Добавить("Нет", НСтр("ru='Отмена'"));
	//ПараметрыВопроса.КнопкаПоУмолчанию = "Да";
	//СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(Оповещение, 
	//	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	//		НСтр("ru = 'Приступить к обновлению адресного классификатора на версию от %1?'"),
	//		Формат(ДанныеОбновления.ВерсияПоследнегоОбновленияКЛАДР, "ДЛФ=D")
	//	) + Символы.ПС + Символы.ПС + Текст, Кнопки, ПараметрыВопроса);
	
КонецПроцедуры

// Завершение модального получения подтверждения о получении ресурсов на проверку наличия обновления классификатора
//
Процедура ПолучениеРазрешенияБезопасностиПроверкиНаличияОбновленияАдресныхОбъектов(Знач РезультатЗакрытия, Знач ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия <> КодВозвратаДиалога.ОК Тогда
		// Нет разрешения
		Возврат;
	КонецЕсли;
	
	// Есть разрешение, можно идти на сервер
	Результат = С_АдресныйКлассификаторВызовСервера.ПроверитьОбновлениеАдресныхОбъектовСервер();
	ОбработкаНеобходимостиОбновленияАдресныхОбъектов(Результат);
	
КонецПроцедуры

// Завершение модального диалога вопроса необходимости обновления
//
Процедура ОпределитьНеобходимостьОбновленияАдресныхОбъектовЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
#Если ВебКлиент Тогда
	Возврат;
#КонецЕсли

	Если РезультатВопроса <> Неопределено И РезультатВопроса.Значение = "Да" Тогда
		ОткрытьФорму("РегистрСведений.С_АдресныйКлассификатор.Форма.ЗагрузкаАдресногоКлассификатора",	
			Новый Структура("АдресныеОбъекты", ДополнительныеПараметры));
	КонецЕсли;
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Содержит полный список файлов данных КЛАДР
//
Функция СписокФайловДанных() Экспорт
	
	Список = Новый Массив;
	
	Список.Добавить("CITY.DBF");
	Список.Добавить("NNUL.DBF");
    
   	Возврат Список;
	
КонецФункции

// Заменяет в имени файла расширение с ".DBF" на ".EXE"
//
// Параметры:
//    Строка - Строка - строка с расширением "DBF".
//
// Возвращаемое значение:
//    Строка - строка с расширением "EXE".
//
Функция ЗаменитьРасширение_DBF_На_EXE(Строка)
	
	Возврат СтрЗаменить(Строка, ".DBF", ".EXE");
	
КонецФункции

// Заменяет в имени файла расширение на c ".DBF" на ".ZIP"
//
// Параметры:
//    Строка - Строка - строка с расширением "DBF".
//
// Возвращаемое значение:
//    Строка - Строка с расширением "ZIP".
//
Функция ЗаменитьРасширение_DBF_На_ZIP(Строка) Экспорт
	
	Возврат СтрЗаменить(Строка, ".DBF", ".ZIP");
	
КонецФункции

// Заменяет в имени файла расширение на c ".EXE" на ".DBF"
//
// Параметры:
//    Строка - Строка - строка с расширением "EXE".
//
// Возвращаемое значение:
//    Строка - строка с расширением "DBF".
//
Функция ЗаменитьРасширение_EXE_На_DBF(Строка) Экспорт
	
	Возврат СтрЗаменить(Строка, ".EXE", ".DBF");
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Блок функций проверки наличия файлов на диске (ИТС)

// Проверяет существование файлов адресного классификатора на диске ИТС.
//
// Параметры:
//     ПутьКДискуИТС - Строка - путь к корню диска ИТС
// 
// Возвращаемое значение:
//     Булево - истина - файлы присутствуют
//              ложь   - файлы отсутствуют
//
Функция ПроверитьНаличиеФайловНаДискеИТС(Знач ПутьКДискуИТС) Экспорт
	
	// Если был выбран диск - то убираем последний символ "\"
	ПравыйСимвол = Прав(ПутьКДискуИТС, 1);
	Если ПравыйСимвол = "\" Или ПравыйСимвол = "/" Тогда
		ПутьКДискуИТС = Лев(ПутьКДискуИТС, СтрДлина(ПутьКДискуИТС) - 1);
	КонецЕсли;
	
	ПутьКДискуИТС = ПутьКДискуИТС + ПутьККаталогуСДаннымиКЛАДРНаДискеИТС(ПутьКДискуИТС);
	
	СписокФайловДанных = СписокФайловДанныхНаДискеИТС();
	
	Для Каждого ПутьКФайлу Из СписокФайловДанных Цикл
		ПолныйПутьКФайлу = ПутьКДискуИТС + ПутьКФайлу;
		Если ПутьКФайлу = "ALTNAMES.EXE" Тогда
			Продолжить;
		КонецЕсли;
		
		ФайлНаДиске = Новый Файл(ПолныйПутьКФайлу);
		Если Не ФайлНаДиске.Существует() Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Функция возвращает относительный путь на диске ИТС по которому находятся файлы КЛАДР.
// 
// Параметры:
//    ПутьКДискуИТС - Строка - путь к корневому каталогу диска ИТС.
// 
// Возвращаемое значение:
//    Строка - относительный путь на диске ИТС к файлам КЛАДР (самораспаковывающийся архив).
//             если файлы не найдены, возвращается пустая строка.
//
Функция ПутьККаталогуСДаннымиКЛАДРНаДискеИТС(Знач ПутьКДискуИТС) Экспорт
	
	ВозможныеПути = Новый Массив;
	ВозможныеПути.Добавить("\1CIts\EXE\KLADR\");
	ВозможныеПути.Добавить("\1CitsFr\EXE\KLADR\");
	ВозможныеПути.Добавить("\1CItsB\EXE\KLADR");
	
	ПравыйСимвол = Прав(ПутьКДискуИТС, 1);
	Если ПравыйСимвол = "\" Или ПравыйСимвол = "/" Тогда
		ПутьКДискуИТС = Лев(ПутьКДискуИТС, СтрДлина(ПутьКДискуИТС) - 1);
	КонецЕсли;
	
	Для Каждого Путь Из ВозможныеПути Цикл
		ПолныйПутьКФайлу = ПутьКДискуИТС + Путь +"STREET.EXE" ;
		ФайлНаДиске = Новый Файл(ПолныйПутьКФайлу);
		Если ФайлНаДиске.Существует() Тогда
			Возврат Путь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

// Содержит полный список файлов данных КЛАДР (в формате самораспаковывающегося архива, EXE)
//
// Возвращаемое значение:
//    Массив - список файлов данных КЛАДР.
//
Функция СписокФайловДанныхНаДискеИТС() Экспорт
	
	Список = СписокФайловДанных();
	
	Для Каждого ИмяФайла Из Список Цикл
		НовоеИмя = ЗаменитьРасширение_DBF_На_EXE(ИмяФайла);
		Список.Установить(Список.Найти(ИмяФайла), НовоеИмя);
	КонецЦикла;
	
	Возврат Список;
	
КонецФункции

// Проверяет существование файлов данных в переданном каталоге
//
// Параметры:
//    ПутьККаталогу - Строка - путь к каталогу, который необходимо проверить на наличие файлов
// 
// Возвращаемое значение:
//    Булево - Истина, если файлы существуют на диске, Ложь, если нет хотя бы одного файла из необходимого набора файлов
//
Функция ПроверитьНаличиеФайловДанныхВКаталоге(Знач ПутьККаталогу) Экспорт
	
	Если ПустаяСтрока(ПутьККаталогу) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Прав(ПутьККаталогу, 1) <> "\" Тогда
		ПутьККаталогу = ПутьККаталогу + "\";
	КонецЕсли;
	
	Для Каждого ПутьКФайлу Из СписокФайловДанных() Цикл
		ФайлНаДиске = Новый Файл(ПутьККаталогу+ПутьКФайлу);
		Если Не ФайлНаДиске.Существует() Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Открывает форму выбора уровня - разрыв взаимозависимости систем
//
Функция ОткрытьФормуВыбораКЛАДР(ПараметрыФормы = Неопределено, Владелец = Неопределено, Уникальность = Неопределено, Окно = Неопределено, НавигационнаяСсылка = Неопределено, ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт
	
	Возврат ОткрытьФорму("РегистрСведений.С_АдресныйКлассификатор.Форма.ФормаВыбора", ПараметрыФормы, Владелец, 
		Уникальность, Окно, НавигационнаяСсылка, ОписаниеОповещенияОЗакрытии);
		
	КонецФункции

#Если Не ВебКлиент Тогда

// Распаковывает файлы КЛАДР с диска ИТС и выполняет их архивацию в ZIP-архив.
// 
// Параметры:
//    ДискИТС - Строка - путь к корневой папке диска ИТС
// 
// Возвращаемое значение:
//    Строка - Путь к временному каталогу с файлами архива кладр
//
Функция ПреобразоватьФайлыКЛАДРEXEВZIP(Знач ДискИТС) Экспорт
	
	ВременныйКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла());
	
	СоздатьКаталог(ВременныйКаталог);
	
	Если Прав(ДискИТС, 1) = "\" Тогда
		ДискИТС = Лев(ДискИТС, СтрДлина(ДискИТС) - 1);
	КонецЕсли;
	
	ПутьКФайламНаДискеИТС = ДискИТС + ПутьККаталогуСДаннымиКЛАДРНаДискеИТС(ДискИТС);
	
	СписокФайловДанных = СписокФайловДанныхНаДискеИТС();
	
	Для Каждого ИмяФайла Из СписокФайловДанных Цикл
		Файл = Новый Файл(ПутьКФайламНаДискеИТС + ИмяФайла);
		Если Файл.Существует() Тогда
			КопироватьФайл(ПутьКФайламНаДискеИТС + ИмяФайла, ВременныйКаталог + ИмяФайла);
			Файл = Новый Файл(ВременныйКаталог + ИмяФайла);
			Файл.УстановитьТолькоЧтение(Ложь);
			КомандаСистемы(ИмяФайла + " -s", ВременныйКаталог);
		КонецЕсли;
		
		ФайлDBF = Новый Файл(ВременныйКаталог+ЗаменитьРасширение_EXE_На_DBF(ИмяФайла));
		
		Если Не ФайлDBF.Существует() Тогда
			УдалитьФайлы(ВременныйКаталог);
			Возврат Неопределено;
		КонецЕсли;
		
		СжатьФайл(ВременныйКаталог, ЗаменитьРасширение_EXE_На_DBF(ИмяФайла), ВременныйКаталог);
	КонецЦикла;
	
	Возврат ВременныйКаталог;
	
КонецФункции

// Сжимает файл из поставки КЛАДР в ZIP архив.
//
// Параметры:
//    ПутьКDBFФайлам         - Строка - путь к каталогу с файлами DBF
//    ИмяФайла               - Строка - имя файла, который требуется сжать
//    КаталогВременныхФайлов - Строка - каталог, в который требуется сохранить файл архива
//
Процедура СжатьФайл(Знач ПутьКDBFФайлам, ИмяФайла, КаталогВременныхФайлов) Экспорт
	
	Если Не ЗначениеЗаполнено(КаталогВременныхФайлов) Тогда
		КаталогВременныхФайлов = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла());
		СоздатьКаталог(КаталогВременныхФайлов);
	КонецЕсли;
	
	ФайлDBF = ПутьКDBFФайлам + ИмяФайла;
	Файл = Новый Файл(ФайлDBF);
	Если Файл.Существует() Тогда
		ПутьКФайлуАрхива = КаталогВременныхФайлов + ЗаменитьРасширение_DBF_На_ZIP(ИмяФайла);
		ZIPФайл = Новый ЗаписьZipФайла(ПутьКФайлуАрхива, , , МетодСжатияZIP.Сжатие, УровеньСжатияZIP.Максимальный);
		ZIPФайл.Добавить(ФайлDBF);
		ZIPФайл.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Загружает файлы КЛАДР региона с Веб сервера
//
// Параметры
//    АдресныйОбъект       - Массив    - каждая строка идентификатор адресного объекта в формате NN
//    ДанныеАутентификации - Структура - параметры аутентификации на пользовательском сайте 1С
//                               * КодПользователя - Строка - пользователь (логин)
//                               * Пароль          - Строка - пароль пользователя
//    ВременныйКаталог     - Строка - путь к временному каталогу.
//
// Возвращаемое значение:
//     Структура - описание результата:
//          * Статус            - Булево - успешность загрузки
//          * Путь              - Строка - путь к файлу на сервере, ключ используется только если статус Истина
//          * СообщениеОбОшибке - Строка - сообщение об ошибке, если статус Ложь
//          * Заголовки         - Соответствие - см. описание параметра Заголовки объекта HTTPОтвет
//
Функция ЗагрузитьКЛАДРСВебСервера(Знач АдресныйОбъект, Знач ДанныеАутентификации, ВременныйКаталог) Экспорт
	//
	//URLСтрока = "http://downloads.v8.1c.ru/tmplts/ITS/KLADR/";
	//
	//Если Не ЗначениеЗаполнено(ВременныйКаталог) Тогда
	//	ВременныйКаталог = ПолучитьИмяВременногоФайла();
	//	СоздатьКаталог(ВременныйКаталог);
	//КонецЕсли;
	//
	//ВременныйКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВременныйКаталог);
	//
	//ПараметрыЗагрузкиФайла = Новый Структура;
	//ПараметрыЗагрузкиФайла.Вставить("Пользователь", ДанныеАутентификации.КодПользователя);
	//ПараметрыЗагрузкиФайла.Вставить("Пароль",  ДанныеАутентификации.Пароль);
	//
	//Если АдресныйОбъект = "AL" Тогда
	//	Файл = Новый Файл(ВременныйКаталог + "ALTNAMES.ZIP");
	//	Если Не Файл.Существует() Тогда
	//		ПараметрыЗагрузкиФайла.Вставить("ПутьДляСохранения", ВременныйКаталог + "ALTNAMES.ZIP");
	//		Результат = ПолучениеФайловИзИнтернетаКлиент.СкачатьФайлНаКлиенте(URLСтрока + "ALTNAMES.ZIP",
	//		ПараметрыЗагрузкиФайла);
	//		Если Не Результат.Статус Тогда
	//			Возврат Результат;
	//		КонецЕсли;
	//	КонецЕсли;
	//	
	//ИначеЕсли АдресныйОбъект = "SO" Тогда
	//	Файл = Новый Файл(ВременныйКаталог + "SOCRBASE.ZIP");
	//	Если Не Файл.Существует() Тогда
	//		ПараметрыЗагрузкиФайла.Вставить("ПутьДляСохранения", ВременныйКаталог + "SOCRBASE.ZIP");
	//		Результат = ПолучениеФайловИзИнтернетаКлиент.СкачатьФайлНаКлиенте(URLСтрока + "SOCRBASE.ZIP",
	//		ПараметрыЗагрузкиФайла);
	//		Если Не Результат.Статус Тогда
	//			Возврат Результат;
	//		КонецЕсли;
	//	КонецЕсли;
	//	
	//Иначе
	//	ИмяZIP = "BASE" + АдресныйОбъект + ".ZIP";
	//	ПараметрыЗагрузкиФайла.Вставить("ПутьДляСохранения", ВременныйКаталог + ИмяZIP);
	//	Результат = ПолучениеФайловИзИнтернетаКлиент.СкачатьФайлНаКлиенте(URLСтрока + ИмяZIP,
	//	ПараметрыЗагрузкиФайла);
	//	Если Не Результат.Статус Тогда
	//		Возврат Результат;
	//	КонецЕсли;
	//	
	//КонецЕсли;
	//
	// Успешная загрузка
	//Возврат Результат;
КонецФункции

#КонецЕсли

Функция ЗапрашиватьДоступПриИспользовании()
	
	Возврат Ложь;
	
КонецФункции

// Вызывает диалог выбора каталога
// 
// Параметры:
//     Форма - УправляемаяФорма - вызывающий объект
//     ПутьКДанным          - Строка  - полное имя реквизита формы, содержащего значение каталога. Например "РабочийКаталог" 
//                                      или "Объект.КаталогИзображений"
//     Заголовок            - Строка - Заголовок для диалога 
//     СтандартнаяОбработка - Булево - для использования в обработчике "ПриНачалаВыбора". Будет заполнено значением Ложь
//
Процедура ВыбратьКаталог(Знач Форма, Знач ПутьКДанным, Знач Заголовок = Неопределено, СтандартнаяОбработка = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьКаталогЗавершениеКонтроляРасширенияРаботыСФайлами", ЭтотОбъект, Новый Структура);
	Оповещение.ДополнительныеПараметры.Вставить("Форма",       Форма);
	Оповещение.ДополнительныеПараметры.Вставить("ПутьКДанным", ПутьКДанным);
	Оповещение.ДополнительныеПараметры.Вставить("Заголовок",   Заголовок);
	
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, , Ложь);
КонецПроцедуры

// Завершение немодального выбора каталога
//
Процедура ВыбратьКаталогЗавершениеКонтроляРасширенияРаботыСФайлами(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	Если Результат <> Истина Тогда
		// Отказ от установки расширения
		Возврат;
		
	ИначеЕсли Не ПодключитьРасширениеРаботыСФайлами() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Расширение для работы с файлами не подключено.'"));
		Возврат;
	КонецЕсли;
	
	Форма       = ДополнительныеПараметры.Форма;
	ПутьКДанным = ДополнительныеПараметры.ПутьКДанным;
	Заголовок   = ДополнительныеПараметры.Заголовок;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Если Заголовок <> Неопределено Тогда
		Диалог.Заголовок = Заголовок;
	КонецЕсли;
	
	ВладелецЗначения = Форма;
	ТекущееЗначение  = Форма;
	ИмяРеквизита     = ПутьКДанным;
	
	ЧастиПути = СтрЗаменить(ПутьКДанным, ".", Символы.ПС);
	Для Позиция = 1 По СтрЧислоСтрок(ЧастиПути) Цикл
		ИмяРеквизита     = СтрПолучитьСтроку(ЧастиПути, Позиция);
		ВладелецЗначения = ТекущееЗначение;
		ТекущееЗначение  = ТекущееЗначение[ИмяРеквизита];
	КонецЦикла;
	
	Диалог.Каталог = ТекущееЗначение;
	
	Если Диалог.Выбрать() Тогда
		ВладелецЗначения[ИмяРеквизита] = Диалог.Каталог;
		ДанныеВыбора = Диалог.Каталог;
	КонецЕсли;
	
КонецПроцедуры

// Создает и возвращает временный каталог на клиенте.
//
// Возвращаемое значение:
//     Строка - полное имя созданного каталога
//
Функция ВременныйКаталогКлиента() Экспорт
	
#Если ВебКлиент Тогда
	Разделитель = ПолучитьРазделительПути();
	
	КаталогКлиента = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КаталогВременныхФайлов()) 
		+ Разделитель + Строка(Новый УникальныйИдентификатор) + Разделитель;
#Иначе
	КаталогКлиента = ПолучитьИмяВременногоФайла();
#КонецЕсли

	СоздатьКаталог(КаталогКлиента);
	
	Возврат КаталогКлиента;
КонецФункции

#КонецОбласти