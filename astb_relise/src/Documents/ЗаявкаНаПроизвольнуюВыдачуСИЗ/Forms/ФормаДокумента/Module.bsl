
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект,НОВЫЙ Структура("ИмяЭлементаДляРазмещения","ГруппаДополнительныеРеквизиты"));
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	ЕстьПризвольнаяВыдача = ЕстьДокументПроизвольнойВыдачи();
	
	ЭтаФорма.ТолькоПросмотр 							= ЕстьПризвольнаяВыдача;
	ЭтаФорма.Элементы.ГруппаПредупреждение.Видимость 	= ЕстьПризвольнаяВыдача;
	
	ЭтаФорма.Элементы.МОЛ.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьМассивМОЛСклада(Объект.Склад,Объект.Организация));
	
КонецПроцедуры

&НаСервере
Функция ЕстьДокументПроизвольнойВыдачи()
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВыдачаСредствЗащитыСотруднику.Ссылка
	|ИЗ
	|	Документ.ВыдачаСредствЗащитыСотруднику КАК ВыдачаСредствЗащитыСотруднику
	|ГДЕ
	|	ВыдачаСредствЗащитыСотруднику.Проведен
	|	И ВыдачаСредствЗащитыСотруднику.ДокументОснование = &ДокументОснование";
	
	Запрос.УстановитьПараметр("ДокументОснование",Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции
	
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

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент.Имя = "ТоварыКоличество" Тогда
		Элемент.ТекущиеДанные.Сумма = Элемент.ТекущиеДанные.Количество * Элемент.ТекущиеДанные.Цена;
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "ТоварыНоменклатура" Тогда
		Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Номенклатура) Тогда
			Элемент.ТекущиеДанные.Цена 				= ПолучитьЦенуСервер(Элемент.ТекущиеДанные.Номенклатура);
			Элемент.ТекущиеДанные.Сумма 			= Элемент.ТекущиеДанные.Количество * Элемент.ТекущиеДанные.Цена;
			Элемент.Текущиеданные.НоменклатураНормы = ПредопределенноеЗначение("Справочник.НоменклатураНормОрганизации.ПустаяСсылка");
		Иначе
			Элемент.ТекущиеДанные.Цена = 0;
			Элемент.ТекущиеДанные.Сумма = 0;
		КонецЕсли;
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "ТоварыЦена" Тогда
		Элемент.ТекущиеДанные.Сумма = Элемент.ТекущиеДанные.Количество * Элемент.ТекущиеДанные.Цена;
	КонецЕсли;
	
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма");
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураНормыПриИзменении(Элемент)
	
	Элементы.Товары.ТекущиеДанные.Номенклатура 					= ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
	Элементы.Товары.ТекущиеДанные.ХарактеристикаНоменклатуры	= ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка");
	Элементы.Товары.ТекущиеДанные.Цена 							= 0;
	Элементы.Товары.ТекущиеДанные.Сумма 						= 0;
	
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборНоменклатурыВыдачи(Команда)
	
	АдресВременногоХранилища = ВыгрузитьТаблицуДокументаВоВременноеХранилище();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Склад", 							Объект.Склад);
	ПараметрыФормы.Вставить("АдресВременногоХранилищаТаблицы", 	АдресВременногоХранилища);
	ПараметрыФормы.Вставить("Организация", 						Объект.Организация);
	ПараметрыФормы.Вставить("Поставщик", 						ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка"));
	ПараметрыФормы.Вставить("Документ", 						Объект.Ссылка);
	
	ОткрытьФорму("Обработка.ПодборНоменклатурыВыдачи.Форма.ФормаПодбора", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЦенуСервер(Номенклатура)
	
	Цена = ЦенообразованиеСерверПереопределяемый.ПолучитьЦену(Номенклатура,Объект.Организация,Объект.Дата);
	Возврат Цена;
	
КонецФункции

&НаСервере
Функция ВыгрузитьТаблицуДокументаВоВременноеХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Товары.Выгрузить(),ЭтаФорма.УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатурыВыдачи.Форма.ФормаПодбора" Тогда
		
		ПолучитьРезультатПодбораИзХранилища(ВыбранноеЗначение.АдресРезультатаПодбораВХранилище);
		
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;

	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьРезультатПодбораИзХранилища(АдресРезультатаПодбораВХранилище)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	
	ТаблицаПодбора = ПолучитьИзВременногоХранилища(АдресРезультатаПодбораВХранилище);
	
	ТекущийОбъект.Товары.Загрузить(ТаблицаПодбора);	
	
	ТекущийОбъект.СуммаДокумента = ТекущийОбъект.Товары.Итог("Сумма");
	
	ЗначениеВРеквизитФормы(ТекущийОбъект,"Объект");
	
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

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ...

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	//АСТБ_ALEXEY_70409**************************************************************
	//Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация);
	Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация,Объект.СоздательДокумента);
	//АСТБ_ALEXEY_70409**************************************************************
	Элементы.МОЛ.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьМассивМОЛСклада(Объект.Склад,Объект.Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	//АСТБ_ALEXEY_69654_**************************************************************
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		Объект.Склад = ПроцедурыРаботыСНормамиСервер.ПолучитьСкладОрганизации(Объект.Организация);
	КонецЕсли;	
	//АСТБ_ALEXEY_69654_**************************************************************
	
	//АСТБ_ALEXEY_70409**************************************************************
	//Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация);
	Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация,Объект.СоздательДокумента);
	//АСТБ_ALEXEY_70409**************************************************************
	Элементы.МОЛ.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьМассивМОЛСклада(Объект.Склад,Объект.Организация));
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	// {ЮМадатов (12.08.21): <#108824>
	Объект.МВЗ = ПроцедурыРаботыСНормамиСервер.ПолучитьМВЗСотрудника(Объект.Сотрудник, Объект.Ссылка); 
	// } ЮМадатов (12.08.21): <#108824>
КонецПроцедуры
