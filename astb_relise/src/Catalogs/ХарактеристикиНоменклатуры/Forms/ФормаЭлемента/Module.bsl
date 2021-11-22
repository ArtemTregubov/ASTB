////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект,НОВЫЙ Структура("ИмяЭлементаДляРазмещения","ГруппаДополнительныеРеквизиты"));
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
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
Процедура МетрикаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Метрика) Тогда
		
		ЗаполнитьРеквизитыНаСервере();
		
	КонецЕсли;
	
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
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ...

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ЗаполнитьРеквизитыНаСервере()
	
	Объект.Код 			= Объект.Метрика.Код;
	Объект.Наименование = Объект.Метрика.Наименование;
	//АсТБ_Alexey_57659_********************************************************************
	Объект.КодSAP		= ОпределитьКодSAP();
	//АсТБ_Alexey_57659_********************************************************************
	
КонецПроцедуры

//АсТБ_Alexey_57659_********************************************************************
&НаСервере
Функция ОпределитьКодSAP()
	
	Если НЕ ЗначениеЗаполнено(Объект.Метрика) Тогда
		Возврат "";
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ХарактеристикиНоменклатуры.КодSAP КАК КодSAP
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Метрика = &Метрика
	|	И НЕ ХарактеристикиНоменклатуры.КодSAP = """"";
	
	Запрос.УстановитьПараметр("Метрика",Объект.Метрика);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат "";
	Иначе
		Возврат Результат.Выгрузить()[0].КодSAP;
	КонецЕсли;	
	
КонецФункции	
//АсТБ_Alexey_57659_********************************************************************