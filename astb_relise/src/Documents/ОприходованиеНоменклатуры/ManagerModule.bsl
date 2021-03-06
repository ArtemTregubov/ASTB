#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ОприходованиеНоменклатурыТовары.Номенклатура КАК Номенклатура,
	|	ОприходованиеНоменклатурыТовары.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ОприходованиеНоменклатурыТовары.Количество КАК Количество,
	|	ОприходованиеНоменклатурыТовары.НомерСтроки КАК НомерСтроки,
	|	ОприходованиеНоменклатурыТовары.Ссылка.Склад КАК Склад,
	|	&ОрганизацияДляОстатков КАК Организация,
	|	ОприходованиеНоменклатурыТовары.Ссылка.Дата КАК Период,
	|	ОприходованиеНоменклатурыТовары.ПроцентИзноса КАК ПроцентИзноса
	|ИЗ
	|	Документ.ОприходованиеНоменклатуры.Товары КАК ОприходованиеНоменклатурыТовары
	|ГДЕ
	|	ОприходованиеНоменклатурыТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",ДокументСсылка);
	Запрос.УстановитьПараметр("ОрганизацияДляОстатков",?(ПолучитьФункциональнуюОпцию("НеВестиУчетОстатковНоменклатурыПоОрганизации"),Справочники.Организации.ПустаяСсылка(),ДокументСсылка.Организация));
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	
	ТаблицыДляДвижений.Вставить("ТаблицаОстаткиНоменклатуры", Результат);
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Оприходование") Тогда

		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"Оприходование",
			"Оприходование номенклатуры",
			СформироватьПечатнуюФормуОприходование(МассивОбъектов, ОбъектыПечати),,"Документ.ОприходованиеНоменклатуры.ПФ_MXL_ОприходованиеНоменклатуры");
				
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОприходованиеСИзносом") Тогда

		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ОприходованиеСИзносом",
			"Оприходование номенклатуры (с % износа)",
			СформироватьПечатнуюФормуОприходованиеСИзносом(МассивОбъектов, ОбъектыПечати),,"Документ.ОприходованиеНоменклатуры.ПФ_MXL_ОприходованиеНоменклатурыСИзносом");
				
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЭтикеткиСИзносом") Тогда

		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ЭтикеткиСИзносом",
			"Этикетки (с % износа)",
			СформироватьПечатнуюФормуЭтикетокСИзносом(МассивОбъектов, ОбъектыПечати),,"Документ.ОприходованиеНоменклатуры.ПФ_MXL_ЭтикеткиСИзносом");
				
	КонецЕсли;
		
КонецПроцедуры

Функция СформироватьПечатнуюФормуОприходование(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОприходованиеНоменклатуры_ОприходованиеНоменклатуры";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Документы.Ссылка КАК Ссылка,
	|	Документы.Организация.НаименованиеПолное КАК ПредставлениеОрганизации,
	|	Документы.Номер КАК Номер,
	|	Документы.Дата КАК Дата,
	|	Документы.Склад.Наименование КАК ПредставлениеСклада,
	|	Документы.Организация.Префикс КАК Префикс,
	|	ПРЕДСТАВЛЕНИЕ(Документы.ДокументОснование) КАК ПредставлениеОснования
	|ИЗ
	|	Документ.ОприходованиеНоменклатуры КАК Документы
	|ГДЕ
	|	Документы.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.Количество КАК Количество,
	|	Товары.Цена КАК Цена,
	|	Товары.Сумма КАК Сумма,
	|	ВЫБОР
	|		КОГДА Товары.ХарактеристикаНоменклатуры = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|			ТОГДА Товары.Номенклатура.Наименование
	|		ИНАЧЕ Товары.Номенклатура.Наименование + "" ("" + Товары.ХарактеристикаНоменклатуры.Наименование + "")""
	|	КОНЕЦ КАК НаименованиеТовара,
	|	ВЫБОР
	|		КОГДА Товары.Ссылка.Организация.ДополнительнаяИнформацияПоНоменклатуреДляПечатныхФорм = ЗНАЧЕНИЕ(Перечисление.ВидДополнительнойИнформацииПоНоменклатуре.Артикул)
	|			ТОГДА Товары.Номенклатура.Артикул
	|		ИНАЧЕ ВЫБОР
	|				КОГДА Товары.Ссылка.Организация.ДополнительнаяИнформацияПоНоменклатуреДляПечатныхФорм = ЗНАЧЕНИЕ(Перечисление.ВидДополнительнойИнформацииПоНоменклатуре.Код)
	|					ТОГДА Товары.Номенклатура.Код
	|				ИНАЧЕ ВЫБОР
	|						КОГДА Товары.Ссылка.Организация.ДополнительнаяИнформацияПоНоменклатуреДляПечатныхФорм = ЗНАЧЕНИЕ(Перечисление.ВидДополнительнойИнформацииПоНоменклатуре.КодСинхронизации)
	|							ТОГДА Товары.Номенклатура.КодСинхронизации
	|						ИНАЧЕ ВЫБОР
	|								КОГДА Товары.Ссылка.Организация.ДополнительнаяИнформацияПоНоменклатуреДляПечатныхФорм = ЗНАЧЕНИЕ(Перечисление.ВидДополнительнойИнформацииПоНоменклатуре.НоменклатурныйНомерОрганизации)
	|									ТОГДА ЕСТЬNULL(НоменклатурныеНомераОрганизаций.НоменклатурныйНомер, """")
	|								ИНАЧЕ """"
	|							КОНЕЦ
	|					КОНЕЦ
	|			КОНЕЦ
	|	КОНЕЦ КАК НоменклатурныйНомер,
	|	Товары.Номенклатура.ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмеренияНаименование,
	|	Товары.НомерСтроки
	|ИЗ
	|	Документ.ОприходованиеНоменклатуры.Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатурныеНомераОрганизаций КАК НоменклатурныеНомераОрганизаций
	|		ПО Товары.Ссылка.Организация = НоменклатурныеНомераОрганизаций.Организация
	|			И Товары.Номенклатура = НоменклатурныеНомераОрганизаций.Номенклатура
	|			И Товары.ХарактеристикаНоменклатуры = НоменклатурныеНомераОрганизаций.ХарактеристикаНоменклатуры
	|ГДЕ
	|	Товары.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Товары.НомерСтроки
	|ИТОГИ ПО
	|	Ссылка");
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОприходованиеНоменклатуры.ПФ_MXL_ОприходованиеНоменклатуры");
	
	ПакетЗапросов = Запрос.ВыполнитьПакет();
	ДанныеПечати = ПакетЗапросов[0].Выбрать();
	ВыборкаПоДокументам = ПакетЗапросов[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		Если НЕ ВыборкаПоДокументам.НайтиСледующий(Новый Структура("Ссылка", ДанныеПечати.Ссылка)) Тогда
			Продолжить;
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
			
		Область = Макет.ПолучитьОбласть("Шапка");
		Область.Параметры.Заполнить(ДанныеПечати);
		
		Область.Параметры.ТекстЗаголовка = ПроцедурыРаботыСНормамиСервер.СформироватьЗаголовокДокумента(Новый Структура("Номер, Дата, Префикс", ДанныеПечати.Номер, ДанныеПечати.Дата, ДанныеПечати.Префикс), "Оприходование номенклатуры");
		ТабличныйДокумент.Вывести(Область);
			
		СчетСтрок = 1;
		ВыборкаПоТоварам = ВыборкаПоДокументам.Выбрать();
		Пока ВыборкаПоТоварам.Следующий() Цикл
			
			Область = Макет.ПолучитьОбласть("СтрокаТаблицы");
			Область.Параметры.Заполнить(ВыборкаПоТоварам);
			ТабличныйДокумент.Вывести(Область);
			
			СчетСтрок = СчетСтрок + 1;
			
		КонецЦикла;
		
		Область = Макет.ПолучитьОбласть("Подвал");
		ТекстИтоговойСтроки = НСтр("ru = 'Всего наименований %ВсегоНаименований%'");
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%ВсегоНаименований%", СчетСтрок-1);
		Область.Параметры.ИтоговаяСтрока = ТекстИтоговойСтроки;
		ТабличныйДокумент.Вывести(Область);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция СформироватьПечатнуюФормуОприходованиеСИзносом(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОприходованиеНоменклатуры_ОприходованиеНоменклатурыСИзносом";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Документы.Ссылка КАК Ссылка,
	|	Документы.Организация.НаименованиеПолное КАК ПредставлениеОрганизации,
	|	Документы.Номер КАК Номер,
	|	Документы.Дата КАК Дата,
	|	Документы.Склад.Наименование КАК ПредставлениеСклада,
	|	Документы.Организация.Префикс КАК Префикс,
	|	ПРЕДСТАВЛЕНИЕ(Документы.ДокументОснование) КАК ПредставлениеОснования
	|ИЗ
	|	Документ.ОприходованиеНоменклатуры КАК Документы
	|ГДЕ
	|	Документы.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.Количество КАК Количество,
	|	Товары.Цена КАК Цена,
	|	Товары.Сумма КАК Сумма,
	|	ВЫБОР
	|		КОГДА Товары.ХарактеристикаНоменклатуры = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|			ТОГДА Товары.Номенклатура.Наименование
	|		ИНАЧЕ Товары.Номенклатура.Наименование + "" ("" + Товары.ХарактеристикаНоменклатуры.Наименование + "")""
	|	КОНЕЦ КАК НаименованиеТовара,
	|	ВЫБОР
	|		КОГДА Товары.Ссылка.Организация.ДополнительнаяИнформацияПоНоменклатуреДляПечатныхФорм = ЗНАЧЕНИЕ(Перечисление.ВидДополнительнойИнформацииПоНоменклатуре.Артикул)
	|			ТОГДА Товары.Номенклатура.Артикул
	|		ИНАЧЕ ВЫБОР
	|				КОГДА Товары.Ссылка.Организация.ДополнительнаяИнформацияПоНоменклатуреДляПечатныхФорм = ЗНАЧЕНИЕ(Перечисление.ВидДополнительнойИнформацииПоНоменклатуре.Код)
	|					ТОГДА Товары.Номенклатура.Код
	|				ИНАЧЕ ВЫБОР
	|						КОГДА Товары.Ссылка.Организация.ДополнительнаяИнформацияПоНоменклатуреДляПечатныхФорм = ЗНАЧЕНИЕ(Перечисление.ВидДополнительнойИнформацииПоНоменклатуре.КодСинхронизации)
	|							ТОГДА Товары.Номенклатура.КодСинхронизации
	|						ИНАЧЕ ВЫБОР
	|								КОГДА Товары.Ссылка.Организация.ДополнительнаяИнформацияПоНоменклатуреДляПечатныхФорм = ЗНАЧЕНИЕ(Перечисление.ВидДополнительнойИнформацииПоНоменклатуре.НоменклатурныйНомерОрганизации)
	|									ТОГДА ЕСТЬNULL(НоменклатурныеНомераОрганизаций.НоменклатурныйНомер, """")
	|								ИНАЧЕ """"
	|							КОНЕЦ
	|					КОНЕЦ
	|			КОНЕЦ
	|	КОНЕЦ КАК НоменклатурныйНомер,
	|	Товары.Номенклатура.ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмеренияНаименование,
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.ПроцентИзноса КАК ПроцентИзноса
	|ИЗ
	|	Документ.ОприходованиеНоменклатуры.Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатурныеНомераОрганизаций КАК НоменклатурныеНомераОрганизаций
	|		ПО Товары.Ссылка.Организация = НоменклатурныеНомераОрганизаций.Организация
	|			И Товары.Номенклатура = НоменклатурныеНомераОрганизаций.Номенклатура
	|			И Товары.ХарактеристикаНоменклатуры = НоменклатурныеНомераОрганизаций.ХарактеристикаНоменклатуры
	|ГДЕ
	|	Товары.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Товары.НомерСтроки
	|ИТОГИ ПО
	|	Ссылка");
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОприходованиеНоменклатуры.ПФ_MXL_ОприходованиеНоменклатурыСИзносом");
	
	ПакетЗапросов = Запрос.ВыполнитьПакет();
	ДанныеПечати = ПакетЗапросов[0].Выбрать();
	ВыборкаПоДокументам = ПакетЗапросов[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		Если НЕ ВыборкаПоДокументам.НайтиСледующий(Новый Структура("Ссылка", ДанныеПечати.Ссылка)) Тогда
			Продолжить;
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
			
		Область = Макет.ПолучитьОбласть("Шапка");
		Область.Параметры.Заполнить(ДанныеПечати);
		
		Область.Параметры.ТекстЗаголовка = ПроцедурыРаботыСНормамиСервер.СформироватьЗаголовокДокумента(Новый Структура("Номер, Дата, Префикс", ДанныеПечати.Номер, ДанныеПечати.Дата, ДанныеПечати.Префикс), "Оприходование номенклатуры");
		ТабличныйДокумент.Вывести(Область);
			
		СчетСтрок = 1;
		ВыборкаПоТоварам = ВыборкаПоДокументам.Выбрать();
		Пока ВыборкаПоТоварам.Следующий() Цикл
			
			Область = Макет.ПолучитьОбласть("СтрокаТаблицы");
			Область.Параметры.Заполнить(ВыборкаПоТоварам);
			ТабличныйДокумент.Вывести(Область);
			
			СчетСтрок = СчетСтрок + 1;
			
		КонецЦикла;
		
		Область = Макет.ПолучитьОбласть("Подвал");
		ТекстИтоговойСтроки = НСтр("ru = 'Всего наименований %ВсегоНаименований%'");
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%ВсегоНаименований%", СчетСтрок-1);
		Область.Параметры.ИтоговаяСтрока = ТекстИтоговойСтроки;
		ТабличныйДокумент.Вывести(Область);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция СформироватьПечатнуюФормуЭтикетокСИзносом(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОприходованиеНоменклатуры_ЭтикеткиСИзносом";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Товары.Ссылка.Организация.Наименование КАК ПредставлениеОрганизации,
	|	ВЫБОР
	|		КОГДА Товары.ХарактеристикаНоменклатуры = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|			ТОГДА Товары.Номенклатура.Наименование
	|		ИНАЧЕ Товары.Номенклатура.Наименование + "" / "" + Товары.ХарактеристикаНоменклатуры.Наименование
	|	КОНЕЦ КАК ПредставлениеСИЗ,
	|	Товары.Ссылка.Дата КАК Дата,
	|	Товары.Количество КАК Количество,
	|	Товары.Номенклатура.КодСинхронизации КАК КодСинхронизации,
	|	Товары.ПроцентИзноса КАК ПроцентИзноса
	|ИЗ
	|	Документ.ОприходованиеНоменклатуры.Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатурныеНомераОрганизаций КАК НоменклатурныеНомераОрганизаций
	|		ПО Товары.Ссылка.Организация = НоменклатурныеНомераОрганизаций.Организация
	|			И Товары.Номенклатура = НоменклатурныеНомераОрганизаций.Номенклатура
	|			И Товары.ХарактеристикаНоменклатуры = НоменклатурныеНомераОрганизаций.ХарактеристикаНоменклатуры
	|ГДЕ
	|	Товары.Ссылка В(&МассивОбъектов)
	|	И НЕ Товары.ПроцентИзноса = ЗНАЧЕНИЕ(Справочник.ПроцентыИзноса.Пустаяссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Товары.Ссылка,
	|	Товары.НомерСтроки");
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОприходованиеНоменклатуры.ПФ_MXL_ЭтикеткиСИзносом");
	
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаТаблицыЗапроса Из ТаблицаЗапроса Цикл
		
		ПредставлениеСИЗ 			= "(" + СтрокаТаблицыЗапроса.КодСинхронизации + ") " +СтрокаТаблицыЗапроса.ПредставлениеСИЗ;
		ПредставлениеДаты 			= "Дата возврата: " + Формат(СтрокаТаблицыЗапроса.Дата,"ДЛФ=DD");
		ПредставлениеПроцентаИзноса = "Износ " + СтрокаТаблицыЗапроса.ПроцентИзноса + "%";
		
		Для Сч = 1 По СтрокаТаблицыЗапроса.Количество Цикл
		
			Область = Макет.ПолучитьОбласть("Этикетка");
		    Область.Параметры.ПредставлениеОрганизации 		= СтрокаТаблицыЗапроса.ПредставлениеОрганизации;
			Область.Параметры.ПредставлениеСИЗ 				= ПредставлениеСИЗ;
			Область.Параметры.ДатаВозврата 					= ПредставлениеДаты;
			Область.Параметры.ПредставлениеПроцентаИзноса 	= ПредставлениеПроцентаИзноса;
			
			ТабличныйДокумент.Вывести(Область);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	//оприходование
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ОприходованиеНоменклатуры";
	КомандаПечати.Идентификатор = "Оприходование";
	КомандаПечати.Представление = НСтр("ru = 'Оприходование номенклатуры'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	//оприходование с учетом износа
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ОприходованиеНоменклатуры";
	КомандаПечати.Идентификатор = "ОприходованиеСИзносом";
	КомандаПечати.Представление = НСтр("ru = 'Оприходование номенклатуры (с % износа)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ФункциональныеОпции = "ИспользоватьПроцентИзноса";
	КомандаПечати.СписокФорм =   		"ФормаДокумента";
	
	//этикетки с % износа
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ОприходованиеНоменклатуры";
	КомандаПечати.Идентификатор = "ЭтикеткиСИзносом";
	КомандаПечати.Представление = НСтр("ru = 'Этикетки (с % износа)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ФункциональныеОпции = "ИспользоватьПроцентИзноса";
	КомандаПечати.СписокФорм =   		"ФормаДокумента";
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОснованию(ТекущийОбъект,Основание) Экспорт
	
	ТекущийОбъект.Организация 		= Основание.Организация;
	ТекущийОбъект.Склад 			= Основание.Склад;
	ТекущийОбъект.ДокументОснование = Основание;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИнвентаризацияНоменклатурыТовары.Номенклатура КАК Номенклатура,
	|	ИнвентаризацияНоменклатурыТовары.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ВЫБОР
	|		КОГДА ИнвентаризацияНоменклатурыТовары.ПроцентИзноса = ИнвентаризацияНоменклатурыТовары.ПроцентИзносаПоУчету
	|			ТОГДА ИнвентаризацияНоменклатурыТовары.Количество - ИнвентаризацияНоменклатурыТовары.КоличествоПоУчету
	|		ИНАЧЕ ИнвентаризацияНоменклатурыТовары.Количество
	|	КОНЕЦ КАК Количество,
	|	ИнвентаризацияНоменклатурыТовары.Цена КАК Цена,
	|	ВЫБОР
	|		КОГДА ИнвентаризацияНоменклатурыТовары.ПроцентИзноса = ЗНАЧЕНИЕ(Справочник.ПроцентыИзноса.ПустаяСсылка)
	|			ТОГДА ИнвентаризацияНоменклатурыТовары.Цена * (ИнвентаризацияНоменклатурыТовары.Количество - ИнвентаризацияНоменклатурыТовары.КоличествоПоУчету)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Сумма,
	|	ИнвентаризацияНоменклатурыТовары.ПроцентИзноса КАК ПроцентИзноса
	|ИЗ
	|	Документ.ИнвентаризацияНоменклатуры.Товары КАК ИнвентаризацияНоменклатурыТовары
	|ГДЕ
	|	(ИнвентаризацияНоменклатурыТовары.Количество - ИнвентаризацияНоменклатурыТовары.КоличествоПоУчету > 0
	|			ИЛИ НЕ ИнвентаризацияНоменклатурыТовары.ПроцентИзноса = ИнвентаризацияНоменклатурыТовары.ПроцентИзносаПоУчету)
	|	И ИнвентаризацияНоменклатурыТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",Основание);
	
	ТекущийОбъект.Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	
	ТекущийОбъект.СуммаДокумента = ТекущийОбъект.Товары.Итог("Сумма");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой ЗапретРедактированияРеквизитовОбъектов.

// Возвращает описание блокируемых реквизитов.
//
// Возвращаемое значение:
//     Массив - содержит строки в формате ИмяРеквизита[;ИмяЭлементаФормы,...]
//              где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы - имя элемента формы, связанного с
//              реквизитом.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
    Результат.Добавить("ВходящийНомер");
    Возврат Результат;
	
КонецФункции

#КонецЕсли