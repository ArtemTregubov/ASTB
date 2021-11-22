////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект,НОВЫЙ Структура("ИмяЭлементаДляРазмещения","ГруппаДополнительныеРеквизиты"));
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	Если Параметры.Ключ.Пустая() Тогда //т.е. создается новый документ
		Объект.Операция = Перечисления.ВидыОперацийКомплектации.Комплектация;
	Иначе
		Если Объект.Товары.Количество()>0 Тогда
			ПроверитьКомплектующиеНаСервере();
		Конецесли;
	КонецЕсли;
	
	НастроитьЭлементыФормы();
	
	//***НСК Трегубов А.А.*** -- Адресное хранение --  02.09.2019 <<<
	АХ_ПриСозданииНаСервере(Отказ,СтандартнаяОбработка);
	//***НСК Трегубов А.А.*** -- Адресное хранение --  02.09.2019 >>>
	
	ЭтаФорма.Элементы.МОЛ.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьМассивМОЛСклада(Объект.Склад,Объект.Организация));
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормы()
	
	Если Объект.Проведен Тогда
		ЭтаФорма.Элементы.ТаблицаКомплектацииНедостача.Видимость = Ложь;
	КонецЕсли;	
			
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДеревоДанных()
	
	ЭлементыДерева = ЭтаФорма.ТаблицаКомплектации.ПолучитьЭлементы();
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		ЭтаФорма.Элементы.ТаблицаКомплектации.Развернуть(ЭлементДерева.ПолучитьИдентификатор(),Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	//***НСК Трегубов А.А.*** -- Адресное хранение --  03.09.2019 <<<
	АХ_ПослеЗаписиНаСервере(ТекущийОбъект,ПараметрыЗаписи);
	//***НСК Трегубов А.А.*** -- Адресное хранение --  03.09.2019 >>>
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "СВОЙСТВА"

// СтандартныеПодсистемы.Свойства
 &НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "ПЕЧАТЬ"

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
  УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
  
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ...

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Функция ПолучитьЦенуСервер(Номенклатура)
	Цена = ЦенообразованиеСерверПереопределяемый.ПолучитьЦену(Номенклатура,Объект.Организация,Объект.Дата);
	Возврат Цена;
КонецФункции


&НаКлиенте
Процедура ПодборНоменклатурыВыдачи(Команда)
	
	АдресВременногоХранилища = ВыгрузитьТаблицуДокументаВоВременноеХранилище();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Склад", 							Объект.Склад);
	ПараметрыФормы.Вставить("ОперацияКомплектации",             Объект.Операция);
	ПараметрыФормы.Вставить("АдресВременногоХранилищаТаблицы", 	АдресВременногоХранилища);
	ПараметрыФормы.Вставить("Организация", 						Объект.Организация);
	ПараметрыФормы.Вставить("Поставщик", 						ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка"));
	ПараметрыФормы.Вставить("Документ", 						Объект.Ссылка);
	
	ОткрытьФорму("Обработка.ПодборНоменклатурыВыдачи.Форма.ФормаПодбораКомплектов", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Функция ВыгрузитьТаблицуДокументаВоВременноеХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Товары.Выгрузить(),ЭтаФорма.УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатурыВыдачи.Форма.ФормаПодбораКомплектов" Тогда
		
		ПолучитьРезультатПодбораИзХранилища(ВыбранноеЗначение.АдресРезультатаПодбораВХранилище);
		
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;

	Модифицированность = Истина;
	ПроверитьКомплектующиеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьРезультатПодбораИзХранилища(АдресРезультатаПодбораВХранилище)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	
	ТаблицаПодбора = ПолучитьИзВременногоХранилища(АдресРезультатаПодбораВХранилище);
	
	ТекущийОбъект.Товары.Загрузить(ТаблицаПодбора);	
	
	Объект.СуммаДокумента = ТекущийОбъект.Товары.Итог("Сумма");
	
	ЗначениеВРеквизитФормы(ТекущийОбъект,"Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	ПроверитьКомплектующиеНаСервере();
	
КонецПроцедуры	

&НаСервере
Функция ПолучитьКомплектующие(Товар, Метрика, Количество)
	
	ТаблРез = Новый ТаблицаЗначений;
	ТаблРез.Колонки.Добавить("Номенклатура");
	ТаблРез.Колонки.Добавить("ХарактеристикаНоменклатуры");
	ТаблРез.Колонки.Добавить("Количество");
	ТаблРез.Колонки.Добавить("Недостача");
	ТаблРез.Колонки.Добавить("Цена");
	ТаблРез.Колонки.Добавить("Сумма");
	
	Запрос = Новый Запрос;
	
	Если Объект.Операция = Перечисления.ВидыОперацийКомплектации.Комплектация Тогда
		Запрос.Текст = 
		//АсТБ_Alexey_77312_********************************************************************
		"ВЫБРАТЬ
		|	ХарактеристикиНоменклатуры.Владелец КАК Владелец,
		|	ХарактеристикиНоменклатуры.Метрика КАК Метрика
		|ПОМЕСТИТЬ ВТ_МетрикиКомплектующих
		|ИЗ
		|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
		|ГДЕ
		|	ХарактеристикиНоменклатуры.Владелец В(&МассивКомплектующих)
		|	И ХарактеристикиНоменклатуры.Метрика = &Метрика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиНоменклатурыОстатки.Номенклатура КАК Номенклатура,
		|	ЕСТЬNULL(ОстаткиНоменклатурыОстатки.ХарактеристикаНоменклатуры.Метрика, ЗНАЧЕНИЕ(Справочник.Метрики.ПустаяСсылка)) КАК Метрика,
		|	СУММА(ОстаткиНоменклатурыОстатки.КоличествоОстаток) КАК КоличествоОстаток
		|ПОМЕСТИТЬ ВТ_Остатки
		|ИЗ
		|	РегистрНакопления.ОстаткиНоменклатуры.Остатки(
		|			&Дата,
		|			Склад = &Склад
		|				И Номенклатура В (&МассивКомплектующих)
		|				И Организация = &Организация) КАК ОстаткиНоменклатурыОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	ОстаткиНоменклатурыОстатки.Номенклатура,
		|	ЕСТЬNULL(ОстаткиНоменклатурыОстатки.ХарактеристикаНоменклатуры.Метрика, ЗНАЧЕНИЕ(Справочник.Метрики.ПустаяСсылка))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НоменклатураКомплектующие.Номенклатура КАК Номенклатура,
		|	НоменклатураКомплектующие.Количество КАК Количество,
		|	ЕСТЬNULL(МАКСИМУМ(ЦеныНоменклатурыСрезПоследних.Цена), 0) КАК Цена,
		|	ЕСТЬNULL(ВТ_МетрикиКомплектующих.Метрика, ЗНАЧЕНИЕ(Справочник.Метрики.ПустаяСсылка)) КАК Метрика
		|ПОМЕСТИТЬ ВТ_Результат
		|ИЗ
		|	Справочник.Номенклатура.Комплектующие КАК НоменклатураКомплектующие
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Дата, Организация = &Организация1) КАК ЦеныНоменклатурыСрезПоследних
		|		ПО НоменклатураКомплектующие.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
		|			И НоменклатураКомплектующие.Номенклатура.Поставщик = ЦеныНоменклатурыСрезПоследних.Поставщик
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_МетрикиКомплектующих КАК ВТ_МетрикиКомплектующих
		|		ПО НоменклатураКомплектующие.Номенклатура = ВТ_МетрикиКомплектующих.Владелец
		|ГДЕ
		|	НоменклатураКомплектующие.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	НоменклатураКомплектующие.Номенклатура,
		|	НоменклатураКомплектующие.Количество,
		|	ЕСТЬNULL(ВТ_МетрикиКомплектующих.Метрика, ЗНАЧЕНИЕ(Справочник.Метрики.ПустаяСсылка))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Результат.Номенклатура КАК Номенклатура,
		|	ВТ_Результат.Количество КАК Количество,
		|	ВТ_Результат.Цена КАК Цена,
		|	ВТ_Результат.Метрика КАК Метрика,
		|	ЕСТЬNULL(ВТ_Остатки.КоличествоОстаток, 0) КАК Остаток
		|ИЗ
		|	ВТ_Результат КАК ВТ_Результат
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Остатки КАК ВТ_Остатки
		|		ПО ВТ_Результат.Номенклатура = ВТ_Остатки.Номенклатура
		|			И ВТ_Результат.Метрика = ВТ_Остатки.Метрика
		|АВТОУПОРЯДОЧИВАНИЕ";
	Иначе	
		//при разкомплектации проверяем остатки комплектов, а не комплектующих
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХарактеристикиНоменклатуры.Владелец КАК Владелец,
		|	ХарактеристикиНоменклатуры.Метрика КАК Метрика
		|ПОМЕСТИТЬ ВТ_МетрикиКомплектующих
		|ИЗ
		|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
		|ГДЕ
		|	ХарактеристикиНоменклатуры.Владелец В(&МассивКомплектующих)
		|	И ХарактеристикиНоменклатуры.Метрика = &Метрика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НоменклатураКомплектующие.Номенклатура КАК Номенклатура,
		|	НоменклатураКомплектующие.Количество КАК Количество,
		|	ЕСТЬNULL(ОстаткиНоменклатурыОстатки.КоличествоОстаток, 0) КАК Остаток,
		|	ЕСТЬNULL(МАКСИМУМ(ЦеныНоменклатурыСрезПоследних.Цена), 0) КАК Цена,
		|	ЕСТЬNULL(ВТ_МетрикиКомплектующих.Метрика, ЗНАЧЕНИЕ(Справочник.Метрики.ПустаяСсылка)) КАК Метрика
		|ИЗ
		|	Справочник.Номенклатура.Комплектующие КАК НоменклатураКомплектующие
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОстаткиНоменклатуры.Остатки(
		|				&Дата,
		|				Склад = &Склад
		|					И (&Метрика = ЗНАЧЕНИЕ(Справочник.Метрики.ПустаяСсылка)
		|						ИЛИ ХарактеристикаНоменклатуры.Метрика = &Метрика)
		|					И Номенклатура = &Ссылка
		|					И Организация = &Организация) КАК ОстаткиНоменклатурыОстатки
		|		ПО НоменклатураКомплектующие.Ссылка = ОстаткиНоменклатурыОстатки.Номенклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Дата, Организация = &Организация1) КАК ЦеныНоменклатурыСрезПоследних
		|		ПО НоменклатураКомплектующие.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
		|			И НоменклатураКомплектующие.Номенклатура.Поставщик = ЦеныНоменклатурыСрезПоследних.Поставщик
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_МетрикиКомплектующих КАК ВТ_МетрикиКомплектующих
		|		ПО НоменклатураКомплектующие.Номенклатура = ВТ_МетрикиКомплектующих.Владелец
		|ГДЕ
		|	НоменклатураКомплектующие.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	НоменклатураКомплектующие.Номенклатура,
		|	НоменклатураКомплектующие.Количество,
		|	ЕСТЬNULL(ОстаткиНоменклатурыОстатки.КоличествоОстаток, 0),
		|	ЕСТЬNULL(ВТ_МетрикиКомплектующих.Метрика, ЗНАЧЕНИЕ(Справочник.Метрики.ПустаяСсылка))
		|
		|УПОРЯДОЧИТЬ ПО
		|	Номенклатура
		|АВТОУПОРЯДОЧИВАНИЕ";
		//АсТБ_Alexey_77312_********************************************************************
	КонецЕсли;	
	
	Запрос.УстановитьПараметр("Дата", КонецДня(ТекущаяДата()));
	Запрос.УстановитьПараметр("Ссылка", Товар);
	//АсТБ_Alexey_77312_********************************************************************
	Запрос.УстановитьПараметр("МассивКомплектующих", Товар.Комплектующие.Выгрузить().ВыгрузитьКолонку("Номенклатура"));
	//АсТБ_Alexey_77312_********************************************************************
	Запрос.УстановитьПараметр("Метрика", Метрика);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.УстановитьПараметр("Организация", ?(ПолучитьФункциональнуюОпцию("НеВестиУчетОстатковНоменклатурыПоОрганизации"),Справочники.Организации.ПустаяСсылка(), Объект.Организация));
	Запрос.УстановитьПараметр("Организация1", Объект.Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	//таблица формируется подчти одинаково для сборки и разборки (но разная обработка таблицы в вызывающей ф-ции)
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрТ = ТаблРез.Добавить();
		СтрТ.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
		//АсТБ_Alexey_77312_********************************************************************
		//СтрТ.ХарактеристикаНоменклатуры = Метрика;
		СтрТ.ХарактеристикаНоменклатуры = ВыборкаДетальныеЗаписи.Метрика;
		//АсТБ_Alexey_77312_********************************************************************
		СтрТ.Количество = ВыборкаДетальныеЗаписи.Количество*Количество;
		Если Объект.Операция = Перечисления.ВидыОперацийКомплектации.Комплектация Тогда
			СтрТ.Недостача = ВыборкаДетальныеЗаписи.Остаток - СтрТ.Количество;                //проверяем комплектующие
		Иначе
			СтрТ.Недостача = ВыборкаДетальныеЗаписи.Остаток - Количество;                     //проверяем комплекты
		КонецЕсли;
		СтрТ.Недостача = ?(СтрТ.Недостача < 0,СтрТ.Недостача,0);
		СтрТ.Цена = ВыборкаДетальныеЗаписи.Цена;                        
		СтрТ.Сумма = ВыборкаДетальныеЗаписи.Цена*СтрТ.Количество; 
	КонецЦикла;
	
	Возврат ТаблРез;
	
КонецФункции	

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = ЭтотОбъект.Элементы.ГруппаКомплектующие Тогда
		Если ЭтаФорма.ПересчитатьКомплектацию Тогда
			СтраницыПриСменеСтраницыНаСервере();
		КонецЕсли;	
		РазвернутьДеревоДанных();
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура СтраницыПриСменеСтраницыНаСервере()
	// Вставить содержимое обработчика.
	ПроверитьКомплектующиеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКомплектующие(Команда)
	Если Объект.Товары.Количество()>0 Тогда
		Если ЭтаФорма.ПересчитатьКомплектацию Тогда
			ПроверитьКомплектующиеНаСервере();
		КонецЕсли;
	КонецЕсли;	
	ЭтаФорма.Элементы.Страницы.ТекущаяСтраница = ЭтаФорма.Элементы.ГруппаКомплектующие;
КонецПроцедуры

Процедура СвернутьТаблицуКомплектов()
	ТаблКомплекты = Объект.Товары.Выгрузить();
	
	ТаблКомплекты.Свернуть("Номенклатура, ХарактеристикаНоменклатуры", "Количество");

	Если ТаблКомплекты.Количество() < Объект.Товары.Количество() Тогда
		Объект.Товары.Очистить();
		Объект.Товары.Загрузить(ТаблКомплекты);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьКомплектующиеНаСервере()       //заполняет дерево комплектации
	
	Если Объект.Товары.Количество() = 0 Тогда
		возврат;
	КонецЕсли;	
	
	ДеревоКомплектов = РеквизитФормыВЗначение("ТаблицаКомплектации");
	ДеревоКомплектов.Строки.Очистить();
	
	КорневаяВетка = ДеревоКомплектов.Строки;
	
	СвернутьТаблицуКомплектов();
	
	Для Каждого СтрКомплект Из Объект.Товары Цикл
		Если Не ЗначениеЗаполнено(СтрКомплект.Номенклатура) ИЛИ (СтрКомплект.Количество = 0) Тогда
			Продолжить;
		КонецЕсли;	
		СтрКомпл = КорневаяВетка.Добавить();
		СтрКомпл.Комплект = СтрКомплект.Номенклатура;
		СтрКомпл.Количество = СтрКомплект.Количество;
		СтрКомпл.ХарактеристикаКомплекта = СтрКомплект.ХарактеристикаНоменклатуры.Метрика;
		ТаблКомпл = ПолучитьКомплектующие(СтрКомплект.Номенклатура, СтрКомплект.ХарактеристикаНоменклатуры.Метрика, СтрКомплект.Количество);
		СуммаКомпл = 0;
		Если Объект.Операция = Перечисления.ВидыОперацийКомплектации.Комплектация Тогда
			Для каждого СтрНом Из ТаблКомпл Цикл
				СтрНоменклатура = СтрКомпл.Строки.Добавить();
				СтрНоменклатура.Номенклатура = СтрНом.Номенклатура;
				СтрНоменклатура.ХарактеристикаНоменклатуры = СтрНом.ХарактеристикаНоменклатуры;
				СтрНоменклатура.Количество = СтрНом.Количество;
				СтрНоменклатура.Цена = СтрНом.Цена;
				СтрНоменклатура.Сумма = СтрНом.Сумма;
				СуммаКомпл = СуммаКомпл + СтрНом.Сумма; 
				Если Объект.Проведен Тогда
					СтрНоменклатура.Недостача = 0;
				Иначе
					СтрНоменклатура.Недостача = СтрНом.Недостача;
				КонецЕсли;
			КонецЦикла;
		Иначе     //для разбора
			Для каждого СтрНом Из ТаблКомпл Цикл
				СтрКомпл.Недостача = СтрНом.Недостача; //!!!  в табл. во всех строках остаток комплекта, а не комплектующих
				СтрНоменклатура = СтрКомпл.Строки.Добавить();
				СтрНоменклатура.Номенклатура = СтрНом.Номенклатура;
				СтрНоменклатура.ХарактеристикаНоменклатуры = СтрНом.ХарактеристикаНоменклатуры;
				СтрНоменклатура.Количество = СтрНом.Количество;
				СтрНоменклатура.Цена = СтрНом.Цена;
				СтрНоменклатура.Сумма = СтрНом.Сумма;
				СуммаКомпл = СуммаКомпл + СтрНом.Сумма; 
				СтрНоменклатура.Недостача = 0;
			КонецЦикла;
		КонецЕсли;
		СтрКомпл.Сумма = СуммаКомпл;                            //цену комплекта и при сборке и при разборке считаю от комплектующих 
		СтрКомпл.Цена = СуммаКомпл / СтрКомплект.Количество;    // аналогично и сумма документа по сумме комплектов.
		СтрКомплект.Цена = СтрКомпл.Цена;                       //
		СтрКомплект.Сумма = СтрКомпл.Сумма;                     //
		//СтрКомплект.Цена = ПолучитьЦенуСервер(СтрКомпл.Комплект);      // вариант расчета цены/суммы прямо по цене комплекта без учета комплектующих
		//СтрКомплект.Сумма = СтрКомплект.Цена * СтрКомплект.Количество; //
	КонецЦикла;
	
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма");
	ЗначениеВРеквизитФормы(ДеревоКомплектов, "ТаблицаКомплектации"); 
	ЭтаФорма.ПересчитатьКомплектацию = Ложь;    
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	ПроверитьКомплектующиеНаСервере();
	
	//АСТБ_ALEXEY_70409**************************************************************
	//Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация);
	Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация,Объект.СоздательДокумента);
	//АСТБ_ALEXEY_70409**************************************************************
	Элементы.МОЛ.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьМассивМОЛСклада(Объект.Склад,Объект.Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПроверитьКомплектующиеНаСервере();
	
	//АСТБ_ALEXEY_70409**************************************************************
	//Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация);
	Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация,Объект.СоздательДокумента);
	//АСТБ_ALEXEY_70409**************************************************************
	Элементы.МОЛ.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьМассивМОЛСклада(Объект.Склад,Объект.Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	ПроверитьКомплектующиеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КомплектыПослеУдаления(Элемент)
	// Вставить содержимое обработчика.
	ЭтаФорма.ПересчитатьКомплектацию = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КомплектыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	// Вставить содержимое обработчика.
	ПроверитьКомплектующиеНаСервере();
	
КонецПроцедуры

#Область АдресноеХранение

&НаСервере
Процедура АХ_ПриСозданииНаСервере(Отказ,СтандартнаяОбработка)	
	АХ_УстановитьВидимостьИДоступность();	
КонецПроцедуры

&НаСервере
Процедура АХ_ПослеЗаписиНаСервере(ТекущийОбъект,ПараметрыЗаписи)	
	АХ_УстановитьВидимостьИДоступность();	
КонецПроцедуры

&НаКлиенте
Процедура АХ_ПередатьНаСклад(Команда)
	
	МассивДанных = Новый Массив;
	
	Соответствие = Новый Соответствие;	
	Соответствие.Вставить("ПланСнятияИПоступление",Объект.Ссылка);
	
	МассивДанных.Добавить(Соответствие);
	
	СтруктураОбработкиОшибок = АХ_ОбменКлиент.ИнициализироватьСтруктуруОбработкиОшибок();
	АХ_ОбменКлиент.ПередатьДанныеВАдресноеХранение(МассивДанных,ЭтотОбъект.Модифицированность,СтруктураОбработкиОшибок);
	
	АХ_УстановитьВидимостьИДоступность();	
	
КонецПроцедуры

&НаСервере
Процедура АХ_УстановитьВидимостьИДоступность()
	
	СтруктураСвойствОформления = АХ_ОбменВызовСервера.МожноСформироватьПланСнятияИПоступление(Объект);
	
	Для Каждого Свойство из СтруктураСвойствОформления Цикл
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"АХ_ПередатьНаСклад",
		Свойство.Ключ,	
		Свойство.Значение);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти





