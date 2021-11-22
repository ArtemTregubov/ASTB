Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь; // отключаем стандартный вывод отчета - будем выводить программно 
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();// Получаем настройки отчета
	
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных; // Создаем данные расшифровки 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных; // Создаем компоновщик макета 
	
	ПараметрПериод = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПериодОтчета"));
	Если не ПараметрПериод = Неопределено Тогда
		ДатаНачала 		= ПараметрПериод.Значение.ДатаНачала;
		ДатаОкончания 	= ПараметрПериод.Значение.ДатаОкончания;
		ПараметрПериод.Использование = Истина;
	Иначе
		Возврат;
	КонецЕсли;
	
	ПараметрПоставщик = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Поставщик"));
	Если НЕ ПараметрПоставщик = Неопределено Тогда
		Если ПараметрПоставщик.Использование Тогда
			Поставщик = ПараметрПоставщик.Значение;
		Иначе
			Поставщик = Справочники.Контрагенты.ПустаяСсылка();
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли; 
	
	ПараметрОрганизация = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Организация"));
	Если НЕ ПараметрОрганизация = Неопределено Тогда 
		Если ПараметрОрганизация.Использование Тогда
			Организация = ПараметрОрганизация.Значение;
		Иначе
			Организация = Справочники.Организации.ПустаяСсылка();
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
	
	ПараметрВидВыдачи = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВидВыдачиСИЗ"));
	Если НЕ ПараметрВидВыдачи = Неопределено Тогда 
		Если ПараметрВидВыдачи.Использование Тогда
			ВидВыдачи = ПараметрВидВыдачи.Значение;
		Иначе	 
			ВидВыдачи = Перечисления.ВидыВыдачиСИЗ.ПустаяСсылка();
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;	
	Запрос.Текст = ПолучитьТекстЗапросаПоНоменклатуреНормы();
	Запрос.УстановитьПараметр("Организация",	Организация);
	Запрос.УстановитьПараметр("ВидВыдачиСИЗ",	ВидВыдачи);
	Запрос.УстановитьПараметр("НачалоПериода",	ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода",	ДатаОкончания);

	Результат = Запрос.ВыполнитьПакет();
	
	ТаблицаЗапроса 						= Результат[16].Выгрузить();
	ТаблицаНоменклатурыНормСотрудников 	= Результат[17].Выгрузить();
	
	ТаблицаРазмеров = ПроцедурыРаботыСНормамиСервер.ПодобратьРазмерыДляСотрудников(ТаблицаНоменклатурыНормСотрудников,КонецДня(ДатаОкончания),Организация); 
	
	//заполняем недостающие данные 
	Для Каждого СтрокаТаблицыЗапроса Из ТаблицаЗапроса Цикл
		
		СтруктураПоиска = Новый Структура("Сотрудник, НоменклатураНормы", СтрокаТаблицыЗапроса.Сотрудник ,СтрокаТаблицыЗапроса.НоменклатураНормы);
		
		НайденныеСтроки = ТаблицаРазмеров.НайтиСтроки(СтруктураПоиска);
		
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			
			Если ЗначениеЗаполнено(НайденнаяСтрока.Комплект) Тогда //комплектующие не рассматриваем
				Продолжить;
			КонецЕсли;	
			
			Если ЗначениеЗаполнено(Поставщик) Тогда //нужно проверить поставщика номенклатуры
				Если НЕ НайденнаяСтрока.Номенклатура.Поставщик = Поставщик Тогда
					Продолжить;
				КонецЕсли;	
			КонецЕсли;
			
			СтрокаТаблицыЗапроса.Номенклатура 				= НайденнаяСтрока.Номенклатура; 
			СтрокаТаблицыЗапроса.ХарактеристикаНоменклатуры = НайденнаяСтрока.ХарактеристикаНоменклатуры;
			
			Прервать;
			
		КонецЦикла;	
		
	КонецЦикла;
	
	НаборыВнешнихДанных = Новый Структура;
	НаборыВнешнихДанных.Вставить("ТаблицаДляВывода",ТаблицаЗапроса);
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	// Скомпонуем результат
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	
	//Инициализировать(<Макет>, <ВнешниеНаборыДанных>, <ДанныеРасшифровки>, <ВозможностьИспользованияВнешнихФункций>) 
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,НаборыВнешнихДанных , ДанныеРасшифровки);
	
	ДокументРезультат.Очистить();
	
	// Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры   

Функция ПолучитьТекстЗапросаПоНоменклатуреНормы()
	
	ТекстЗапроса = 	
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПотребностьВыдачиСИЗОстатки.Организация КАК Организация,
	|	ПотребностьВыдачиСИЗОстатки.Сотрудник КАК Сотрудник,
	|	ПотребностьВыдачиСИЗОстатки.НормаВыдачи КАК НормаВыдачи,
	|	ПотребностьВыдачиСИЗОстатки.НоменклатураНормы КАК НоменклатураНормы,
	|	ПотребностьВыдачиСИЗОстатки.ДатаПотребности КАК ДатаПотребности,
	|	ПотребностьВыдачиСИЗОстатки.КоличествоОстаток КАК КоличествоОстаток,
	|	НормыВыдачиСИЗСоставНормы.ПериодичностьВыдачи.Приоритет КАК ПериодичностьВыдачиПриоритет,
	|	ПотребностьВыдачиСИЗОстатки.Организация.СверткаПотребностиПоНоменклатуреНормы КАК ОрганизацияСверткаПотребностиПоНоменклатуреНормы
	|ПОМЕСТИТЬ ПотребностьВыдачиСИЗ
	|ИЗ
	|	РегистрНакопления.ПотребностьВыдачиСИЗ.Остатки(
	|			,
	|			ДатаПотребности >= &НачалоПериода
	|				И ДатаПотребности <= &КонецПериода
	|				И ВЫБОР
	|					КОГДА &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ Организация = &Организация
	|				КОНЕЦ
	|				И ВЫБОР
	|					КОГДА &ВидВыдачиСИЗ = ЗНАЧЕНИЕ(Перечисление.ВидыВыдачиСИЗ.ПустаяСсылка)
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ НормаВыдачи.ВидВыдачиСИЗ = &ВидВыдачиСИЗ
	|				КОНЕЦ) КАК ПотребностьВыдачиСИЗОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НормыВыдачиСИЗ.СоставНормы КАК НормыВыдачиСИЗСоставНормы
	|		ПО ПотребностьВыдачиСИЗОстатки.Организация = НормыВыдачиСИЗСоставНормы.Ссылка.Владелец
	|			И ПотребностьВыдачиСИЗОстатки.НормаВыдачи = НормыВыдачиСИЗСоставНормы.Ссылка
	|			И ПотребностьВыдачиСИЗОстатки.НоменклатураНормы = НормыВыдачиСИЗСоставНормы.НоменклатураНормы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПотребностьВыдачиСИЗ.Организация КАК Организация,
	|	ПотребностьВыдачиСИЗ.Сотрудник КАК Сотрудник,
	|	ПотребностьВыдачиСИЗ.НоменклатураНормы КАК НоменклатураНормы,
	|	МАКСИМУМ(ПотребностьВыдачиСИЗ.ПериодичностьВыдачиПриоритет) КАК ПериодичностьВыдачиПриоритет,
	|	ИСТИНА КАК НормаОптимизирована
	|ПОМЕСТИТЬ КорректировкаПо_хх1х
	|ИЗ
	|	ПотребностьВыдачиСИЗ КАК ПотребностьВыдачиСИЗ
	|
	|СГРУППИРОВАТЬ ПО
	|	ПотребностьВыдачиСИЗ.Организация,
	|	ПотребностьВыдачиСИЗ.Сотрудник,
	|	ПотребностьВыдачиСИЗ.НоменклатураНормы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПотребностьВыдачиСИЗ.Организация КАК Организация,
	|	ПотребностьВыдачиСИЗ.Сотрудник КАК Сотрудник,
	|	ПотребностьВыдачиСИЗ.НормаВыдачи КАК НормаВыдачи,
	|	ПотребностьВыдачиСИЗ.НоменклатураНормы КАК НоменклатураНормы,
	|	ПотребностьВыдачиСИЗ.ДатаПотребности КАК ДатаПотребности,
	|	ПотребностьВыдачиСИЗ.КоличествоОстаток КАК КоличествоОстаток
	|ПОМЕСТИТЬ ПотребностьВыдачиСИЗ_хх1х
	|ИЗ
	|	ПотребностьВыдачиСИЗ КАК ПотребностьВыдачиСИЗ
	|		ЛЕВОЕ СОЕДИНЕНИЕ КорректировкаПо_хх1х КАК КорректировкаПо_хх1х
	|		ПО ПотребностьВыдачиСИЗ.Организация = КорректировкаПо_хх1х.Организация
	|			И ПотребностьВыдачиСИЗ.Сотрудник = КорректировкаПо_хх1х.Сотрудник
	|			И ПотребностьВыдачиСИЗ.ПериодичностьВыдачиПриоритет = КорректировкаПо_хх1х.ПериодичностьВыдачиПриоритет
	|			И ПотребностьВыдачиСИЗ.НоменклатураНормы = КорректировкаПо_хх1х.НоменклатураНормы
	|ГДЕ
	|	(НЕ ПотребностьВыдачиСИЗ.ОрганизацияСверткаПотребностиПоНоменклатуреНормы
	|			ИЛИ ПотребностьВыдачиСИЗ.ОрганизацияСверткаПотребностиПоНоменклатуреНормы
	|				И ЕСТЬNULL(КорректировкаПо_хх1х.НормаОптимизирована, ЛОЖЬ))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗначенияАнтропометрическихСвойств.Сотрудник КАК Сотрудник,
	|	ЗначенияАнтропометрическихСвойств.ВидСвойства КАК ВидСвойства,
	|	ЗначенияАнтропометрическихСвойств.ЗначениеСвойства КАК ЗначениеСвойства
	|ПОМЕСТИТЬ ВТ_АнтропометрияСотрудников
	|ИЗ
	|	РегистрСведений.ЗначенияАнтропометрическихСвойств КАК ЗначенияАнтропометрическихСвойств
	|ГДЕ
	|	НЕ ЗначенияАнтропометрическихСвойств.ВидСвойства = ЗНАЧЕНИЕ(Справочник.ВидыАнтропометрическихСвойств.Рост)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗначенияАнтропометрическихСвойств.Сотрудник КАК Сотрудник,
	|	ЗначенияАнтропометрическихСвойств.ЗначениеСвойства КАК ЗначениеСвойства
	|ПОМЕСТИТЬ ВТ_РостСотрудников
	|ИЗ
	|	РегистрСведений.ЗначенияАнтропометрическихСвойств КАК ЗначенияАнтропометрическихСвойств
	|ГДЕ
	|	ЗначенияАнтропометрическихСвойств.ВидСвойства = ЗНАЧЕНИЕ(Справочник.ВидыАнтропометрическихСвойств.Рост)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПотребностьВыдачиСИЗ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ КорректировкаПо_хх1х
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УточненныеОснованияНормВыдачи.Организация КАК Организация,
	|	УточненныеОснованияНормВыдачи.НормаВыдачи КАК НормаВыдачи,
	|	УточненныеОснованияНормВыдачи.Подразделение КАК Подразделение,
	|	УточненныеОснованияНормВыдачи.Должность КАК Должность,
	|	УточненныеОснованияНормВыдачи.РабочееМесто КАК РабочееМесто,
	|	УточненныеОснованияНормВыдачи.Основание КАК Основание
	|ПОМЕСТИТЬ ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто
	|ИЗ
	|	РегистрСведений.УточненныеОснованияНормВыдачи КАК УточненныеОснованияНормВыдачи
	|ГДЕ
	|	НЕ УточненныеОснованияНормВыдачи.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|	И НЕ УточненныеОснованияНормВыдачи.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
	|	И НЕ УточненныеОснованияНормВыдачи.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМестаАСТБ.ПустаяСсылка)
	|	И ВЫБОР
	|			КОГДА &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УточненныеОснованияНормВыдачи.Организация = &Организация
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ВидВыдачиСИЗ = ЗНАЧЕНИЕ(Перечисление.ВидыВыдачиСИЗ.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УточненныеОснованияНормВыдачи.НормаВыдачи.ВидВыдачиСИЗ = &ВидВыдачиСИЗ
	|		КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	НормаВыдачи,
	|	Подразделение,
	|	Должность,
	|	РабочееМесто
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УточненныеОснованияНормВыдачи.Организация КАК Организация,
	|	УточненныеОснованияНормВыдачи.НормаВыдачи КАК НормаВыдачи,
	|	УточненныеОснованияНормВыдачи.Подразделение КАК Подразделение,
	|	УточненныеОснованияНормВыдачи.Должность КАК Должность,
	|	УточненныеОснованияНормВыдачи.РабочееМесто КАК РабочееМесто,
	|	УточненныеОснованияНормВыдачи.Основание КАК Основание
	|ПОМЕСТИТЬ ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто
	|ИЗ
	|	РегистрСведений.УточненныеОснованияНормВыдачи КАК УточненныеОснованияНормВыдачи
	|ГДЕ
	|	УточненныеОснованияНормВыдачи.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|	И НЕ УточненныеОснованияНормВыдачи.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
	|	И НЕ УточненныеОснованияНормВыдачи.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМестаАСТБ.ПустаяСсылка)
	|	И ВЫБОР
	|			КОГДА &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УточненныеОснованияНормВыдачи.Организация = &Организация
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ВидВыдачиСИЗ = ЗНАЧЕНИЕ(Перечисление.ВидыВыдачиСИЗ.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УточненныеОснованияНормВыдачи.НормаВыдачи.ВидВыдачиСИЗ = &ВидВыдачиСИЗ
	|		КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	НормаВыдачи,
	|	Подразделение,
	|	Должность,
	|	РабочееМесто
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УточненныеОснованияНормВыдачи.Организация КАК Организация,
	|	УточненныеОснованияНормВыдачи.НормаВыдачи КАК НормаВыдачи,
	|	УточненныеОснованияНормВыдачи.Подразделение КАК Подразделение,
	|	УточненныеОснованияНормВыдачи.Должность КАК Должность,
	|	УточненныеОснованияНормВыдачи.РабочееМесто КАК РабочееМесто,
	|	УточненныеОснованияНормВыдачи.Основание КАК Основание
	|ПОМЕСТИТЬ ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто
	|ИЗ
	|	РегистрСведений.УточненныеОснованияНормВыдачи КАК УточненныеОснованияНормВыдачи
	|ГДЕ
	|	НЕ УточненныеОснованияНормВыдачи.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|	И УточненныеОснованияНормВыдачи.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
	|	И НЕ УточненныеОснованияНормВыдачи.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМестаАСТБ.ПустаяСсылка)
	|	И ВЫБОР
	|			КОГДА &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УточненныеОснованияНормВыдачи.Организация = &Организация
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ВидВыдачиСИЗ = ЗНАЧЕНИЕ(Перечисление.ВидыВыдачиСИЗ.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УточненныеОснованияНормВыдачи.НормаВыдачи.ВидВыдачиСИЗ = &ВидВыдачиСИЗ
	|		КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	НормаВыдачи,
	|	Подразделение,
	|	Должность,
	|	РабочееМесто
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УточненныеОснованияНормВыдачи.Организация КАК Организация,
	|	УточненныеОснованияНормВыдачи.НормаВыдачи КАК НормаВыдачи,
	|	УточненныеОснованияНормВыдачи.Подразделение КАК Подразделение,
	|	УточненныеОснованияНормВыдачи.Должность КАК Должность,
	|	УточненныеОснованияНормВыдачи.РабочееМесто КАК РабочееМесто,
	|	УточненныеОснованияНормВыдачи.Основание КАК Основание
	|ПОМЕСТИТЬ ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто
	|ИЗ
	|	РегистрСведений.УточненныеОснованияНормВыдачи КАК УточненныеОснованияНормВыдачи
	|ГДЕ
	|	НЕ УточненныеОснованияНормВыдачи.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|	И НЕ УточненныеОснованияНормВыдачи.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
	|	И УточненныеОснованияНормВыдачи.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМестаАСТБ.ПустаяСсылка)
	|	И ВЫБОР
	|			КОГДА &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УточненныеОснованияНормВыдачи.Организация = &Организация
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ВидВыдачиСИЗ = ЗНАЧЕНИЕ(Перечисление.ВидыВыдачиСИЗ.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УточненныеОснованияНормВыдачи.НормаВыдачи.ВидВыдачиСИЗ = &ВидВыдачиСИЗ
	|		КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	НормаВыдачи,
	|	Подразделение,
	|	Должность,
	|	РабочееМесто
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УточненныеОснованияНормВыдачи.Организация КАК Организация,
	|	УточненныеОснованияНормВыдачи.НормаВыдачи КАК НормаВыдачи,
	|	УточненныеОснованияНормВыдачи.Подразделение КАК Подразделение,
	|	УточненныеОснованияНормВыдачи.Должность КАК Должность,
	|	УточненныеОснованияНормВыдачи.РабочееМесто КАК РабочееМесто,
	|	УточненныеОснованияНормВыдачи.Основание КАК Основание
	|ПОМЕСТИТЬ ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто
	|ИЗ
	|	РегистрСведений.УточненныеОснованияНормВыдачи КАК УточненныеОснованияНормВыдачи
	|ГДЕ
	|	УточненныеОснованияНормВыдачи.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|	И НЕ УточненныеОснованияНормВыдачи.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
	|	И УточненныеОснованияНормВыдачи.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМестаАСТБ.ПустаяСсылка)
	|	И ВЫБОР
	|			КОГДА &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УточненныеОснованияНормВыдачи.Организация = &Организация
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ВидВыдачиСИЗ = ЗНАЧЕНИЕ(Перечисление.ВидыВыдачиСИЗ.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УточненныеОснованияНормВыдачи.НормаВыдачи.ВидВыдачиСИЗ = &ВидВыдачиСИЗ
	|		КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	НормаВыдачи,
	|	Подразделение,
	|	Должность,
	|	РабочееМесто
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УточненныеОснованияНормВыдачи.Организация КАК Организация,
	|	УточненныеОснованияНормВыдачи.НормаВыдачи КАК НормаВыдачи,
	|	УточненныеОснованияНормВыдачи.Подразделение КАК Подразделение,
	|	УточненныеОснованияНормВыдачи.Должность КАК Должность,
	|	УточненныеОснованияНормВыдачи.РабочееМесто КАК РабочееМесто,
	|	УточненныеОснованияНормВыдачи.Основание КАК Основание
	|ПОМЕСТИТЬ ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто
	|ИЗ
	|	РегистрСведений.УточненныеОснованияНормВыдачи КАК УточненныеОснованияНормВыдачи
	|ГДЕ
	|	НЕ УточненныеОснованияНормВыдачи.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|	И УточненныеОснованияНормВыдачи.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
	|	И УточненныеОснованияНормВыдачи.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМестаАСТБ.ПустаяСсылка)
	|	И ВЫБОР
	|			КОГДА &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УточненныеОснованияНормВыдачи.Организация = &Организация
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ВидВыдачиСИЗ = ЗНАЧЕНИЕ(Перечисление.ВидыВыдачиСИЗ.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УточненныеОснованияНормВыдачи.НормаВыдачи.ВидВыдачиСИЗ = &ВидВыдачиСИЗ
	|		КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	НормаВыдачи,
	|	Подразделение,
	|	Должность,
	|	РабочееМесто
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УточненныеОснованияНормВыдачи.Организация КАК Организация,
	|	УточненныеОснованияНормВыдачи.НормаВыдачи КАК НормаВыдачи,
	|	УточненныеОснованияНормВыдачи.Подразделение КАК Подразделение,
	|	УточненныеОснованияНормВыдачи.Должность КАК Должность,
	|	УточненныеОснованияНормВыдачи.РабочееМесто КАК РабочееМесто,
	|	УточненныеОснованияНормВыдачи.Основание КАК Основание
	|ПОМЕСТИТЬ ВТ_УОНВ_Организация_ПустоеПодразделение_ПустаяДолжность_ПустоеРабочееМесто
	|ИЗ
	|	РегистрСведений.УточненныеОснованияНормВыдачи КАК УточненныеОснованияНормВыдачи
	|ГДЕ
	|	УточненныеОснованияНормВыдачи.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|	И УточненныеОснованияНормВыдачи.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
	|	И УточненныеОснованияНормВыдачи.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМестаАСТБ.ПустаяСсылка)
	|	И ВЫБОР
	|			КОГДА &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УточненныеОснованияНормВыдачи.Организация = &Организация
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ВидВыдачиСИЗ = ЗНАЧЕНИЕ(Перечисление.ВидыВыдачиСИЗ.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УточненныеОснованияНормВыдачи.НормаВыдачи.ВидВыдачиСИЗ = &ВидВыдачиСИЗ
	|		КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	НормаВыдачи,
	|	Подразделение,
	|	Должность,
	|	РабочееМесто
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПотребностьВыдачиСИЗОстатки.Организация КАК Организация,
	|	ПотребностьВыдачиСИЗОстатки.Сотрудник КАК Сотрудник,
	|	ПотребностьВыдачиСИЗОстатки.НормаВыдачи КАК НормаВыдачи,
	|	ПотребностьВыдачиСИЗОстатки.НормаВыдачи.ВидВыдачиСИЗ КАК ВидВыдачиСИЗ,
	|	ПотребностьВыдачиСИЗОстатки.НоменклатураНормы КАК НоменклатураНормы,
	|	НАЧАЛОПЕРИОДА(ПотребностьВыдачиСИЗОстатки.ДатаПотребности, МЕСЯЦ) КАК ДатаПотребности,
	|	СУММА(ПотребностьВыдачиСИЗОстатки.КоличествоОстаток) КАК Количество_00х1,
	|	ОсновноеМестоРаботыСотрудникаСрезПоследних.Подразделение КАК Подразделение,
	|	ОсновноеМестоРаботыСотрудникаСрезПоследних.Должность КАК Должность,
	|	ОсновноеМестоРаботыСотрудникаСрезПоследних.РабочееМесто КАК РабочееМесто,
	|	ПотребностьВыдачиСИЗОстатки.ДатаПотребности КАК РеальнаяДатаПотребности,
	|	ВЫБОР
	|		КОГДА ВТ_АнтропометрияСотрудников.ВидСвойства ЕСТЬ NULL
	|			ТОГДА ПотребностьВыдачиСИЗОстатки.НоменклатураНормы.ВидАнтропометрическогоСвойства
	|		ИНАЧЕ ВТ_АнтропометрияСотрудников.ВидСвойства
	|	КОНЕЦ КАК ВидАнтропометрии,
	|	ЕСТЬNULL(ВТ_АнтропометрияСотрудников.ЗначениеСвойства, """") КАК ЗначениеАнтропометрии,
	|	ВЫБОР
	|		КОГДА ПотребностьВыдачиСИЗОстатки.НоменклатураНормы.ИспользоватьРост
	|			ТОГДА ЕСТЬNULL(ВТ_РостСотрудников.ЗначениеСвойства, """")
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Рост,
	|	КОНЕЦПЕРИОДА(НАЧАЛОПЕРИОДА(ПотребностьВыдачиСИЗОстатки.ДатаПотребности, МЕСЯЦ), МЕСЯЦ) КАК КонецМесяца
	|ПОМЕСТИТЬ ВТ_ИсходныеДанные
	|ИЗ
	|	ПотребностьВыдачиСИЗ_хх1х КАК ПотребностьВыдачиСИЗОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ОсновноеМестоРаботыСотрудникаСрезПоследних.Организация КАК Организация,
	|			ОсновноеМестоРаботыСотрудникаСрезПоследних.Сотрудник КАК Сотрудник,
	|			ОсновноеМестоРаботыСотрудникаСрезПоследних.Подразделение КАК Подразделение,
	|			ОсновноеМестоРаботыСотрудникаСрезПоследних.Должность КАК Должность,
	|			ОсновноеМестоРаботыСотрудникаСрезПоследних.РабочееМесто КАК РабочееМесто
	|		ИЗ
	|			РегистрСведений.ОсновноеМестоРаботыСотрудника.СрезПоследних(
	|					&КонецПериода,
	|					ВЫБОР
	|						КОГДА &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ Организация = &Организация
	|					КОНЕЦ) КАК ОсновноеМестоРаботыСотрудникаСрезПоследних
	|		ГДЕ
	|			ОсновноеМестоРаботыСотрудникаСрезПоследних.ОсновноеМестоРаботы = ИСТИНА) КАК ОсновноеМестоРаботыСотрудникаСрезПоследних
	|		ПО ПотребностьВыдачиСИЗОстатки.Организация = ОсновноеМестоРаботыСотрудникаСрезПоследних.Организация
	|			И ПотребностьВыдачиСИЗОстатки.Сотрудник = ОсновноеМестоРаботыСотрудникаСрезПоследних.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_АнтропометрияСотрудников КАК ВТ_АнтропометрияСотрудников
	|		ПО ПотребностьВыдачиСИЗОстатки.Сотрудник = ВТ_АнтропометрияСотрудников.Сотрудник
	|			И ПотребностьВыдачиСИЗОстатки.НоменклатураНормы.ВидАнтропометрическогоСвойства = ВТ_АнтропометрияСотрудников.ВидСвойства
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_РостСотрудников КАК ВТ_РостСотрудников
	|		ПО ПотребностьВыдачиСИЗОстатки.Сотрудник = ВТ_РостСотрудников.Сотрудник
	|			И (ВЫБОР
	|				КОГДА ПотребностьВыдачиСИЗОстатки.НоменклатураНормы.ИспользоватьРост
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПотребностьВыдачиСИЗОстатки.Организация,
	|	ПотребностьВыдачиСИЗОстатки.Сотрудник,
	|	ПотребностьВыдачиСИЗОстатки.НормаВыдачи,
	|	ПотребностьВыдачиСИЗОстатки.НормаВыдачи.ВидВыдачиСИЗ,
	|	ПотребностьВыдачиСИЗОстатки.НоменклатураНормы,
	|	НАЧАЛОПЕРИОДА(ПотребностьВыдачиСИЗОстатки.ДатаПотребности, МЕСЯЦ),
	|	ОсновноеМестоРаботыСотрудникаСрезПоследних.Подразделение,
	|	ОсновноеМестоРаботыСотрудникаСрезПоследних.Должность,
	|	ОсновноеМестоРаботыСотрудникаСрезПоследних.РабочееМесто,
	|	ПотребностьВыдачиСИЗОстатки.ДатаПотребности,
	|	ВЫБОР
	|		КОГДА ВТ_АнтропометрияСотрудников.ВидСвойства ЕСТЬ NULL
	|			ТОГДА ПотребностьВыдачиСИЗОстатки.НоменклатураНормы.ВидАнтропометрическогоСвойства
	|		ИНАЧЕ ВТ_АнтропометрияСотрудников.ВидСвойства
	|	КОНЕЦ,
	|	ЕСТЬNULL(ВТ_АнтропометрияСотрудников.ЗначениеСвойства, """"),
	|	ВЫБОР
	|		КОГДА ПотребностьВыдачиСИЗОстатки.НоменклатураНормы.ИспользоватьРост
	|			ТОГДА ЕСТЬNULL(ВТ_РостСотрудников.ЗначениеСвойства, """")
	|		ИНАЧЕ """"
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВыданныеСредстваЗащитыОстатки.Сотрудник КАК Сотрудник,
	|	ВыданныеСредстваЗащитыОстатки.НормаВыдачи КАК НормаВыдачи,
	|	ВыданныеСредстваЗащитыОстатки.НоменклатураНормы КАК НоменклатураНормы,
	|	ВыданныеСредстваЗащитыОстатки.ДатаВыдачи КАК ДатаВыдачи,
	|	СУММА(ВыданныеСредстваЗащитыОстатки.КоличествоОстаток) КАК Количество_ххх2,
	|	ВыданныеСредстваЗащитыОстатки.Организация КАК Организация
	|ПОМЕСТИТЬ ВТ_ВыдачаПо0012
	|{ВЫБРАТЬ
	|	Организация,
	|	Сотрудник,
	|	НормаВыдачи,
	|	НоменклатураНормы,
	|	ДатаВыдачи}
	|ИЗ
	|	РегистрНакопления.ВыданныеСредстваЗащиты.Остатки(
	|			,
	|			Организация.ИспользоватьАлгоритм_0_0_1_2
	|				И ВЫБОР
	|					КОГДА &ВидВыдачиСИЗ = ЗНАЧЕНИЕ(Перечисление.ВидыВыдачиСИЗ.ПустаяСсылка)
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ НормаВыдачи.ВидВыдачиСИЗ = &ВидВыдачиСИЗ
	|				КОНЕЦ) КАК ВыданныеСредстваЗащитыОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ВыданныеСредстваЗащитыОстатки.НормаВыдачи,
	|	ВыданныеСредстваЗащитыОстатки.Сотрудник,
	|	ВыданныеСредстваЗащитыОстатки.НоменклатураНормы,
	|	ВыданныеСредстваЗащитыОстатки.ДатаВыдачи,
	|	ВыданныеСредстваЗащитыОстатки.Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ИсходныеДанные.Организация КАК Организация,
	|	ВТ_ИсходныеДанные.Сотрудник КАК Сотрудник,
	|	ВТ_ИсходныеДанные.НормаВыдачи КАК НормаВыдачи,
	|	ВТ_ИсходныеДанные.ВидВыдачиСИЗ КАК ВидВыдачиСИЗ,
	|	ВТ_ИсходныеДанные.НоменклатураНормы КАК НоменклатураНормы,
	|	ВТ_ИсходныеДанные.ДатаПотребности КАК ДатаПотребности,
	|	ВТ_ИсходныеДанные.Количество_00х1 - ЕСТЬNULL(ВТ_ВыдачаПо0012.Количество_ххх2, 0) КАК Количество,
	|	ВТ_ИсходныеДанные.Подразделение КАК Подразделение,
	|	ВТ_ИсходныеДанные.Должность КАК Должность,
	|	ВТ_ИсходныеДанные.РабочееМесто КАК РабочееМесто,
	|	ВТ_ИсходныеДанные.ВидАнтропометрии КАК ВидАнтропометрии,
	|	ВТ_ИсходныеДанные.ЗначениеАнтропометрии КАК ЗначениеАнтропометрии,
	|	ВТ_ИсходныеДанные.Рост КАК Рост,
	|	ВЫБОР
	|		КОГДА ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто.Основание ЕСТЬ NULL
	|			ТОГДА ВЫБОР
	|					КОГДА ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто.Основание ЕСТЬ NULL
	|						ТОГДА ВЫБОР
	|								КОГДА ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто.Основание ЕСТЬ NULL
	|									ТОГДА ВЫБОР
	|											КОГДА ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто.Основание ЕСТЬ NULL
	|												ТОГДА ВЫБОР
	|														КОГДА ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто.Основание ЕСТЬ NULL
	|															ТОГДА ВЫБОР
	|																	КОГДА ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто.Основание ЕСТЬ NULL
	|																		ТОГДА ВЫБОР
	|																				КОГДА ВТ_УОНВ_Организация_ПустоеПодразделение_ПустаяДолжность_ПустоеРабочееМесто.Основание ЕСТЬ NULL
	|																					ТОГДА """"
	|																				ИНАЧЕ ВТ_УОНВ_Организация_ПустоеПодразделение_ПустаяДолжность_ПустоеРабочееМесто.Основание
	|																			КОНЕЦ
	|																	ИНАЧЕ ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто.Основание
	|																КОНЕЦ
	|														ИНАЧЕ ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто.Основание
	|													КОНЕЦ
	|											ИНАЧЕ ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто.Основание
	|										КОНЕЦ
	|								ИНАЧЕ ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто.Основание
	|							КОНЕЦ
	|					ИНАЧЕ ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто.Основание
	|				КОНЕЦ
	|		ИНАЧЕ ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто.Основание
	|	КОНЕЦ КАК Основание,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК Номенклатура,
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК ХарактеристикаНоменклатуры
	|ИЗ
	|	ВТ_ИсходныеДанные КАК ВТ_ИсходныеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто КАК ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто
	|		ПО ВТ_ИсходныеДанные.Подразделение = ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто.Подразделение
	|			И ВТ_ИсходныеДанные.НормаВыдачи = ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто.НормаВыдачи
	|			И ВТ_ИсходныеДанные.Должность = ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто.Должность
	|			И ВТ_ИсходныеДанные.РабочееМесто = ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто.РабочееМесто
	|			И ВТ_ИсходныеДанные.Организация = ВТ_УОНВ_Организация_Подразделение_Должность_РабочееМесто.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто КАК ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто
	|		ПО ВТ_ИсходныеДанные.НормаВыдачи = ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто.НормаВыдачи
	|			И ВТ_ИсходныеДанные.Должность = ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто.Должность
	|			И ВТ_ИсходныеДанные.РабочееМесто = ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто.РабочееМесто
	|			И ВТ_ИсходныеДанные.Организация = ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_РабочееМесто.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто КАК ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто
	|		ПО ВТ_ИсходныеДанные.НормаВыдачи = ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто.НормаВыдачи
	|			И ВТ_ИсходныеДанные.Подразделение = ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто.Подразделение
	|			И ВТ_ИсходныеДанные.РабочееМесто = ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто.РабочееМесто
	|			И ВТ_ИсходныеДанные.Организация = ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_РабочееМесто.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто КАК ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто
	|		ПО ВТ_ИсходныеДанные.Подразделение = ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто.Подразделение
	|			И ВТ_ИсходныеДанные.НормаВыдачи = ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто.НормаВыдачи
	|			И ВТ_ИсходныеДанные.Должность = ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто.Должность
	|			И ВТ_ИсходныеДанные.Организация = ВТ_УОНВ_Организация_Подразделение_Должность_ПустоеРабочееМесто.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто КАК ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто
	|		ПО ВТ_ИсходныеДанные.НормаВыдачи = ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто.НормаВыдачи
	|			И ВТ_ИсходныеДанные.Должность = ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто.Должность
	|			И ВТ_ИсходныеДанные.Организация = ВТ_УОНВ_Организация_ПустоеПодразделение_Должность_ПустоеРабочееМесто.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто КАК ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто
	|		ПО ВТ_ИсходныеДанные.НормаВыдачи = ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто.НормаВыдачи
	|			И ВТ_ИсходныеДанные.Подразделение = ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто.Подразделение
	|			И ВТ_ИсходныеДанные.Организация = ВТ_УОНВ_Организация_Подразделение_ПустаяДолжность_ПустоеРабочееМесто.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УОНВ_Организация_ПустоеПодразделение_ПустаяДолжность_ПустоеРабочееМесто КАК ВТ_УОНВ_Организация_ПустоеПодразделение_ПустаяДолжность_ПустоеРабочееМесто
	|		ПО ВТ_ИсходныеДанные.НормаВыдачи = ВТ_УОНВ_Организация_ПустоеПодразделение_ПустаяДолжность_ПустоеРабочееМесто.НормаВыдачи
	|			И ВТ_ИсходныеДанные.Организация = ВТ_УОНВ_Организация_ПустоеПодразделение_ПустаяДолжность_ПустоеРабочееМесто.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВыдачаПо0012 КАК ВТ_ВыдачаПо0012
	|		ПО ВТ_ИсходныеДанные.Организация = ВТ_ВыдачаПо0012.Организация
	|			И ВТ_ИсходныеДанные.Сотрудник = ВТ_ВыдачаПо0012.Сотрудник
	|			И ВТ_ИсходныеДанные.НормаВыдачи = ВТ_ВыдачаПо0012.НормаВыдачи
	|			И ВТ_ИсходныеДанные.НоменклатураНормы = ВТ_ВыдачаПо0012.НоменклатураНормы
	|			И ВТ_ИсходныеДанные.РеальнаяДатаПотребности = ВТ_ВыдачаПо0012.ДатаВыдачи
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаПотребности
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_ИсходныеДанные.Сотрудник КАК Сотрудник,
	|	ВТ_ИсходныеДанные.НоменклатураНормы КАК НоменклатураНормы
	|ИЗ
	|	ВТ_ИсходныеДанные КАК ВТ_ИсходныеДанные";	    
	
	Возврат ТекстЗапроса;
	
КонецФункции	