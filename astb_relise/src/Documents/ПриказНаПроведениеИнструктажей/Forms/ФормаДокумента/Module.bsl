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

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЭтаФорма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
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

&НаСервере
Процедура ЗаполнитьПоУстановленнымДаннымНаСервере()
	
	Документы.ПриказНаПроведениеИнструктажей.ЗаполнитьТаблицуДокумента(Объект,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоУстановленнымДанным(Команда)
	
	ЗаполнитьПоУстановленнымДаннымНаСервере();
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОтсутствующимДаннымНаСервере()
	
	Документы.ПриказНаПроведениеИнструктажей.ЗаполнитьТаблицуДокумента(Объект,Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОтсутствующимДанным(Команда)
	
	ЗаполнитьПоОтсутствующимДаннымНаСервере();
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РабочиеМестаПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//редактируем периодичность только для повторных инструктажей
	Если Элемент.ТекущийЭлемент.Имя = "РабочиеМестаПериодичность" Тогда
		Отказ = НеРедактироватьПериодичность(Элемент.ТекущиеДанные.Инструктаж);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НеРедактироватьПериодичность(ТекущийИнструктаж)
	
	Возврат НЕ ТекущийИнструктаж.ВидИнструктажа = Перечисления.ВидыИнструктажей.Повторный;
	
КонецФункции	

&НаКлиенте
Процедура РабочиеМестаПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	//редактируем периодичность только для повторных инструктажей
	Если Элемент.ТекущийЭлемент.Имя = "РабочиеМестаПериодичность" Тогда
		Если НеРедактироватьПериодичность(Элемент.ТекущиеДанные.Инструктаж) Тогда
			Элемент.ТекущиеДанные.Периодичность = ПредопределенноеЗначение("Справочник.ПериодичностьВыдачиСИЗ.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	ПоменятьФлажки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	ПоменятьФлажки(Ложь);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоменятьФлажки(ЗначениеФлажка)
	
	Для Каждого СтрокаТаблицы Из Объект.РабочиеМеста Цикл
		
		СтрокаТаблицы.Проводить = ЗначениеФлажка;
		
	КонецЦикла;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РабочиеМестаИнструктажПриИзменении(Элемент)
	
	ТекущиеДанные = ЭтаФорма.Элементы.РабочиеМеста.ТекущиеДанные;
	
	ТекущиеДанные.Периодичность = ПолучитьПериодичностьПоУмолчанию(ТекущиеДанные.Инструктаж);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПериодичностьПоУмолчанию(ТекущийИнструктаж)
	
	Если ТекущийИнструктаж.ВидИнструктажа = Перечисления.ВидыИнструктажей.Повторный Тогда
		Возврат ТекущийИнструктаж.Периодичность;
	Иначе
		Возврат Справочники.ПериодичностьВыдачиСИЗ.ПустаяСсылка();
	КонецЕсли;	
	
КонецФункции	

&НаКлиенте
Процедура ЗаполнитьИнструктажВВыделенныхСтроках(Команда)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна",  РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("РежимВыбора",        Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Ложь);
	ПараметрыФормыВыбора.Вставить("Отбор",              Новый Структура("ЭтоГруппа", Ложь));
	
	ОткрытьФорму("Справочник.Инструктажи.Форма.ФормаВыбора",ПараметрыФормыВыбора,ЭтаФорма,УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ВыделенныеСтроки = Элементы.РабочиеМеста.ВыделенныеСтроки;
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.Инструктажи.Форма.ФормаВыбора" Тогда
		
		Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			
			Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
				
				ТекущаяСтрока = Элементы.РабочиеМеста.ДанныеСтроки(ВыделеннаяСтрока);
				
				ТекущаяСтрока.Инструктаж 	= ВыбранноеЗначение;
				ТекущаяСтрока.Периодичность = ПолучитьПериодичностьПоУмолчанию(ВыбранноеЗначение);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;

	Модифицированность = Истина;
	
КонецПроцедуры


