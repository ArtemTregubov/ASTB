
&НаКлиенте
Процедура Печать(Команда)
	
	ОчиститьСообщения();
	
	Если НЕ ЕстьВыбранныеСИЗ() Тогда
		
		ПоказатьПредупреждение(,НСтр("ru = 'Не выбрано ни одной строки'"));
		Возврат;
		
	КонецЕсли;
	
	ПараметрКоманды = Новый Массив;
	ПараметрКоманды.Добавить(ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка"));

	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.ПечатьЭтикетокДляВыданныхСИЗ","ПФ_MXL_Этикетка",ПараметрКоманды,ЭтаФорма,ПолучитьПараметры());
		 	
КонецПроцедуры

&НаСервере
Функция ЕстьВыбранныеСИЗ()
	
	Результат = Ложь;
	
	Для Каждого СтрокаТаблицы Из Объект.ИсходныеДанные Цикл
		
		Если СтрокаТаблицы.Использовать Тогда
			
			Результат = Истина;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьПараметры()
	
	ДанныеДляПечати = Объект.ИсходныеДанные.Выгрузить();
	ДанныеДляПечати.Очистить();
	
	Для Каждого СтрокаТаблицы ИЗ Объект.ИсходныеДанные Цикл
		
		Если Не СтрокаТаблицы.Использовать Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ДанныеДляПечати.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		
	КонецЦикла;
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ДанныеДляПечати", ПоместитьВоВременноеХранилище(ДанныеДляПечати, ЭтаФорма.УникальныйИдентификатор)); 
	
	Возврат ПараметрыПечати;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.АдресВХранилище) Тогда
		
		СтруктураДанных = ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище);
	
		Объект.ИсходныеДанные.Загрузить(СтруктураДанных.ИсходныеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьМетки(Команда)
	
	Для Каждого СтрокаТаблицы Из Объект.ИсходныеДанные Цикл
		
		СтрокаТаблицы.Использовать = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьМетки(Команда)
	
	Для Каждого СтрокаТаблицы Из Объект.ИсходныеДанные Цикл
		
		СтрокаТаблицы.Использовать = Ложь;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиПоШтрихкоду(Команда)
	
	Перем ВыбЗнач;
	
	ОчиститьСообщения();
	
	Заголовок = НСтр("ru = 'Введите штрихкод'");
	
	Оповещение = Новый ОписаниеОповещения("ПослеВводаЗначения",ЭтаФорма,Параметры);
	
	ПоказатьВводЗначения(Оповещение,ВыбЗнач, Заголовок, Новый ОписаниеТипов("Строка"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаЗначения(ВыбЗнач,Параметры) Экспорт
	
	Если ВыбЗнач = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ НайтиПоШтрихкодуНаСервере(ВыбЗнач) Тогда
		
		Сообщить("Не найдена этикетка по шрихкоду: " + ВыбЗнач);
		
	КонецЕсли;
			
КонецПроцедуры

&НаСервере
Функция НайтиПоШтрихкодуНаСервере(ТекШтрихкод)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ШтрихкодыНоменклатурыДляУчетаЧистки.Штрихкод КАК Штрихкод,
	|	ШтрихкодыНоменклатурыДляУчетаЧистки.Сотрудник КАК Сотрудник,
	|	ШтрихкодыНоменклатурыДляУчетаЧистки.Подразделение КАК Подразделение,
	|	ШтрихкодыНоменклатурыДляУчетаЧистки.МВЗ КАК МВЗ,
	|	ШтрихкодыНоменклатурыДляУчетаЧистки.Номенклатура КАК Номенклатура,
	|	ШтрихкодыНоменклатурыДляУчетаЧистки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ШтрихкодыНоменклатурыДляУчетаЧистки.ДатаВыдачи КАК ДатаВыдачи
	|ПОМЕСТИТЬ ВТ_Штрихкоды
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатурыДляУчетаЧистки КАК ШтрихкодыНоменклатурыДляУчетаЧистки
	|ГДЕ
	|	ШтрихкодыНоменклатурыДляУчетаЧистки.Штрихкод = &Штрихкод
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НоменклатураКомплектующие.Ссылка КАК Комплект,
	|	НоменклатураКомплектующие.Номенклатура
	|ПОМЕСТИТЬ ВТ_Комплектующие
	|ИЗ
	|	Справочник.Номенклатура.Комплектующие КАК НоменклатураКомплектующие
	|ГДЕ
	|	НоменклатураКомплектующие.Номенклатура.ИспользоватьШтрихкод
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВыданныеСредстваЗащитыОстатки.Сотрудник,
	|	ВыданныеСредстваЗащитыОстатки.Номенклатура,
	|	ВыданныеСредстваЗащитыОстатки.ДатаВыдачи,
	|	ВЫБОР
	|		КОГДА НормыВыдачиСИЗСоставНормы.ПериодичностьВыдачи.ТипПериода = ЗНАЧЕНИЕ(Перечисление.ДоступныеПериодыОтчета.Год)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ВыданныеСредстваЗащитыОстатки.ДатаВыдачи, МЕСЯЦ, НормыВыдачиСИЗСоставНормы.ПериодичностьВыдачи.КоличествоПериодов * 12)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(ВыданныеСредстваЗащитыОстатки.ДатаВыдачи, МЕСЯЦ, НормыВыдачиСИЗСоставНормы.ПериодичностьВыдачи.КоличествоПериодов)
	|	КОНЕЦ КАК ДатаОкончанияИспользования
	|ПОМЕСТИТЬ ВТ_ВыдачаСПериодичностью
	|ИЗ
	|	РегистрНакопления.ВыданныеСредстваЗащиты.Остатки(, ) КАК ВыданныеСредстваЗащитыОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НормыВыдачиСИЗ.СоставНормы КАК НормыВыдачиСИЗСоставНормы
	|		ПО ВыданныеСредстваЗащитыОстатки.НормаВыдачи = НормыВыдачиСИЗСоставНормы.Ссылка
	|			И ВыданныеСредстваЗащитыОстатки.НоменклатураНормы = НормыВыдачиСИЗСоставНормы.НоменклатураНормы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ВыдачаСПериодичностью.Сотрудник,
	|	ВЫБОР
	|		КОГДА ВТ_ВыдачаСПериодичностью.Номенклатура.Комплект
	|			ТОГДА ВТ_Комплектующие.Номенклатура
	|		ИНАЧЕ ВТ_ВыдачаСПериодичностью.Номенклатура
	|	КОНЕЦ КАК Номенклатура,
	|	ВТ_ВыдачаСПериодичностью.ДатаВыдачи,
	|	ВТ_ВыдачаСПериодичностью.ДатаОкончанияИспользования
	|ПОМЕСТИТЬ ВТ_ВыдачаСКомплектующими
	|ИЗ
	|	ВТ_ВыдачаСПериодичностью КАК ВТ_ВыдачаСПериодичностью
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Комплектующие КАК ВТ_Комплектующие
	|		ПО ВТ_ВыдачаСПериодичностью.Номенклатура = ВТ_Комплектующие.Комплект
	|ГДЕ
	|	ВЫБОР
	|			КОГДА ВТ_ВыдачаСПериодичностью.Номенклатура.Комплект
	|				ТОГДА НЕ ВТ_Комплектующие.Номенклатура ЕСТЬ NULL 
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Штрихкоды.Штрихкод,
	|	ВТ_Штрихкоды.Сотрудник,
	|	ВТ_Штрихкоды.Подразделение,
	|	ВТ_Штрихкоды.МВЗ,
	|	ВТ_Штрихкоды.Номенклатура,
	|	ВТ_Штрихкоды.ХарактеристикаНоменклатуры,
	|	ВТ_Штрихкоды.ДатаВыдачи,
	|	ВЫБОР
	|		КОГДА ВТ_Штрихкоды.Сотрудник.Владелец.ОтображатьДатуОкончанияСрокаНоскиНаЭтикетках
	|			ТОГДА ЕСТЬNULL(ВТ_ВыдачаСКомплектующими.ДатаОкончанияИспользования, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0))
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	КОНЕЦ КАК ДатаОкончанияИспользования
	|ИЗ
	|	ВТ_Штрихкоды КАК ВТ_Штрихкоды
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВыдачаСКомплектующими КАК ВТ_ВыдачаСКомплектующими
	|		ПО ВТ_Штрихкоды.Сотрудник = ВТ_ВыдачаСКомплектующими.Сотрудник
	|			И ВТ_Штрихкоды.Номенклатура = ВТ_ВыдачаСКомплектующими.Номенклатура
	|			И ВТ_Штрихкоды.ДатаВыдачи = ВТ_ВыдачаСКомплектующими.ДатаВыдачи";
	
	Запрос.УстановитьПараметр("Штрихкод",ТекШтрихкод);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ТекущийОбъект = РеквизитФормыВЗначение("Объект");
		
		ЗаполнитьЗначенияСвойств(ТекущийОбъект.ИсходныеДанные.Добавить(),Выборка);
		
		ЗначениеВРеквизитФормы(ТекущийОбъект,"Объект");
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции
