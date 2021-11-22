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
	
	ЭтаФорма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
	ЭтаФорма.Элементы.МОЛ.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьМассивМОЛСклада(Объект.Склад,Объект.Организация));
	
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

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Элемент.ТекущийЭлемент.Имя = "ТоварыКоличество" Тогда
		Элемент.ТекущиеДанные.Сумма = Элемент.ТекущиеДанные.Количество * Элемент.ТекущиеДанные.Цена;
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "ТоварыНоменклатураДляВыдачи" Тогда
		Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.НоменклатураДляВыдачи) Тогда
			Элемент.ТекущиеДанные.Цена = ПолучитьЦенуСервер(Элемент.ТекущиеДанные.НоменклатураДляВыдачи);
			Элемент.ТекущиеДанные.Сумма = Элемент.ТекущиеДанные.Количество * Элемент.ТекущиеДанные.Цена;
		КонецЕсли;
	КонецЕсли;
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма");
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
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЭтаФорма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
	Объект.Товары.Очистить();
	
	//АСТБ_ALEXEY_70409**************************************************************
	//Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация);
	Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация,Объект.СоздательДокумента);
	//АСТБ_ALEXEY_70409**************************************************************
	Элементы.МОЛ.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьМассивМОЛСклада(Объект.Склад,Объект.Организация));
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЦенуСервер(Номенклатура)
	Цена = ЦенообразованиеСерверПереопределяемый.ПолучитьЦену(Номенклатура,Объект.Организация,Объект.Дата);
	Возврат Цена;
КонецФункции

&НаКлиенте
Процедура ТоварыПриАктивизацииЯчейки(Элемент)
	
	Если Элементы.Товары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если Элемент.ТекущийЭлемент.Имя = "ТоварыНоменклатураДляВыдачи" Тогда
		
		МассивНН = Новый Массив;
		МассивНН.Добавить(ТекущиеДанные.НоменклатураНормыДляВыдачи);
		
		ЭтаФорма.Элементы.Товары.ПодчиненныеЭлементы.ГруппаНоменклатура.ПодчиненныеЭлементы.ТоварыНоменклатураДляВыдачи.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьСписокНоменклатурыПоНоменклатуреНормы(МассивНН,Объект,Объект.Сотрудник));
		
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "ТоварыНоменклатураНормыДляВыдачи" Тогда	
		
		ЭтаФорма.Элементы.Товары.ПодчиненныеЭлементы.ГруппаНоменклатураНормы.ПодчиненныеЭлементы.ТоварыНоменклатураНормыДляВыдачи.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьСписокНоменклатурыНормыПоНормеВыдачи(ТекущиеДанные.НормаВыдачи));
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураДляВыдачиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ТекущиеДанные.ХарактеристикаНоменклатурыДляВыдачи = ПроцедурыРаботыСНормамиСервер.ПолучитьХарактеристикуПоАнтропометрии(ТекущиеДанные.НоменклатураДляВыдачи,Объект.Сотрудник);
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Документы.ОбменСредствЗащитыСотрудника.ЗаполнитьДокумент(Объект);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	Объект.Товары.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураНормыДляВыдачиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ТекущиеДанные.НоменклатураДляВыдачи 				= ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
	ТекущиеДанные.ХарактеристикаНоменклатурыДляВыдачи 	= ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка");
	ТекущиеДанные.Цена 									= 0;
	ТекущиеДанные.Сумма 								= 0;
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	//АСТБ_ALEXEY_70409**************************************************************
	//Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация);
	Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация,Объект.СоздательДокумента);
	//АСТБ_ALEXEY_70409**************************************************************
	Элементы.МОЛ.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьМассивМОЛСклада(Объект.Склад,Объект.Организация));
	
КонецПроцедуры
