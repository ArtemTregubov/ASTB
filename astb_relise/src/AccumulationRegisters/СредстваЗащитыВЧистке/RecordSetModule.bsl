Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Или Не ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	ТребуетсяКонтроль = Истина;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	БлокироватьДляИзменения = Истина;

	// Текущее состояние набора помещается во временную таблицу "ДвиженияСредстваЗащитыВЧисткеПередЗаписью",
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",    ДополнительныеСвойства.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Организация КАК Организация,
	|	Таблица.Контрагент КАК Контрагент,
	|	Таблица.Сотрудник КАК Сотрудник,
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.Количество
	|		ИНАЧЕ -Таблица.Количество
	|	КОНЕЦ КАК КоличествоПередЗаписью,
	|	Таблица.Штрихкод
	|ПОМЕСТИТЬ ДвиженияСредстваЗащитыВЧисткеПередЗаписью
	|ИЗ
	|	РегистрНакопления.СредстваЗащитыВЧистке КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И НЕ &ЭтоНовый";
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)

	Если ОбменДанными.Загрузка Или Не ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;

	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаИзменений.Организация КАК Организация,
	|	ТаблицаИзменений.Контрагент КАК Контрагент,
	|	ТаблицаИзменений.Сотрудник КАК Сотрудник,
	|	ТаблицаИзменений.Номенклатура КАК Номенклатура,
	|	ТаблицаИзменений.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	СУММА(ТаблицаИзменений.КоличествоИзменение) КАК КоличествоИзменение,
	|	ТаблицаИзменений.Штрихкод
	|ПОМЕСТИТЬ ДвиженияСредстваЗащитыВЧисткеИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Организация КАК Организация,
	|		Таблица.Контрагент КАК Контрагент,
	|		Таблица.Сотрудник КАК Сотрудник,
	|		Таблица.Номенклатура КАК Номенклатура,
	|		Таблица.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		Таблица.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		Таблица.Штрихкод КАК Штрихкод
	|	ИЗ
	|		ДвиженияСредстваЗащитыВЧисткеПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.Организация,
	|		Таблица.Контрагент,
	|		Таблица.Сотрудник,
	|		Таблица.Номенклатура,
	|		Таблица.ХарактеристикаНоменклатуры,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.Количество
	|			ИНАЧЕ Таблица.Количество
	|		КОНЕЦ,
	|		Таблица.Штрихкод
	|	ИЗ
	|		РегистрНакопления.СредстваЗащитыВЧистке КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Организация,
	|	ТаблицаИзменений.Контрагент,
	|	ТаблицаИзменений.Сотрудник,
	|	ТаблицаИзменений.Номенклатура,
	|	ТаблицаИзменений.ХарактеристикаНоменклатуры,
	|	ТаблицаИзменений.Штрихкод
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.КоличествоИзменение) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДвиженияСредстваЗащитыВЧисткеПередЗаписью";
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	Выборка.Следующий();
	
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияСредстваЗащитыВЧисткеИзменение", Выборка.Количество > 0);

КонецПроцедуры
