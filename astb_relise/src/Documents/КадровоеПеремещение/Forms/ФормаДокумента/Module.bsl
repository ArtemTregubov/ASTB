////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект,НОВЫЙ Структура("ИмяЭлементаДляРазмещения","ГруппаДополнительныеРеквизиты"));
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	ЭтаФорма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
	ЭтаФорма.Элементы.РаботникиПодборСотрудников.Доступность = НЕ Объект.Проведен;	
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
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
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЭтаФорма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура РаботникиДолжностьСтараяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Работники.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущееПодразделение = ПредопределенноеЗначение("Справочник.Подразделения.ПустаяСсылка");
	Иначе
		ТекущееПодразделение = ТекущиеДанные.ПодразделениеСтарое;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Справочник.ДолжностиИПрофессии.ФормаВыбора",
			Новый Структура("СписокПрофессий", ПолучитьСписокПрофессийНаСервере(ТекущееПодразделение)),Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РаботникиДолжностьНоваяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Работники.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущееПодразделение = ПредопределенноеЗначение("Справочник.Подразделения.ПустаяСсылка");
	Иначе
		ТекущееПодразделение = ТекущиеДанные.ПодразделениеНовое;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Справочник.ДолжностиИПрофессии.ФормаВыбора",
			Новый Структура("СписокПрофессий", ПолучитьСписокПрофессийНаСервере(ТекущееПодразделение)),Элемент);
			
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
Функция ПолучитьСписокПрофессийНаСервере(ТекущееПодразделение)
	
	Возврат ПроцедурыРаботыСНормамиСервер.ПолучитьСписокПрофессийПоШтатномуРасписанию(Объект.Ссылка,ТекущееПодразделение);
	
КонецФункции

//АСТБ_Овсянников_----------------------------------------------------------------
// новый механизм подбора сотрудников

&НаСервере
Функция ВыгрузитьТаблицуДокументаВоВременноеХранилище()
	
	ТаблПодбора = Новый ТаблицаЗначений;
	ТаблПодбора.Колонки.Добавить("Сотрудник");
	ТаблПодбора.Колонки.Добавить("Подразделение");
    ТаблПодбора.Колонки.Добавить("Должность");
    ТаблПодбора.Колонки.Добавить("РабочееМесто");
    ТаблПодбора.Колонки.Добавить("ЗанимаемыхСтавок");
	ТблРаботников = Объект.Работники.Выгрузить();
	Для Каждого Стр Из ТблРаботников Цикл
		СтрП = ТаблПодбора.Добавить();
		СтрП.Сотрудник = Стр.Сотрудник;
		СтрП.Подразделение = Стр.ПодразделениеСтарое;
		СтрП.Должность = Стр.ДолжностьСтарая;
		СтрП.РабочееМесто = Стр.РабочееМестоСтарое;
		СтрП.ЗанимаемыхСтавок = Стр.ЗанимаемыхСтавокСтарое;
    КонецЦикла;	
	Возврат ПоместитьВоВременноеХранилище(ТаблПодбора,ЭтаФорма.УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ПодборСотрудников(Команда)
	
	АдресВременногоХранилища = ВыгрузитьТаблицуДокументаВоВременноеХранилище();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресВременногоХранилищаТаблицы", 	АдресВременногоХранилища);
	ПараметрыФормы.Вставить("Организация", 						Объект.Организация);
	ПараметрыФормы.Вставить("Документ", 						Объект.Ссылка);
	
	ОткрытьФорму("Обработка.ПодборСотрудниковОрганизации.Форма.ФормаПодбора", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьРезультатПодбораИзХранилища(АдресРезультатаПодбораВХранилище)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТаблицаПодбора = ПолучитьИзВременногоХранилища(АдресРезультатаПодбораВХранилище);
	
	//ТекущийОбъект.Работники.Загрузить(ТаблицаПодбора);		
	Для Каждого Стр ИЗ ТаблицаПодбора Цикл
		НайденныеСтроки = ТекущийОбъект.Работники.НайтиСтроки(НОВЫЙ Структура("Сотрудник,ПодразделениеСтарое,ДолжностьСтарая,", Стр.Сотрудник,Стр.Подразделение,Стр.Должность));
		Если НайденныеСтроки.Количество() = 0 Тогда
			ТекущаяСтрока = ТекущийОбъект.Работники.Добавить();
			ТекущаяСтрока.Сотрудник = Стр.Сотрудник;
			ТекущаяСтрока.ПодразделениеСтарое = Стр.Подразделение;
			ТекущаяСтрока.ДолжностьСтарая = Стр.Должность;
			ТекущаяСтрока.РабочееМестоСтарое = Стр.РабочееМесто;
			ТекущаяСтрока.ЗанимаемыхСтавокСтарое = Стр.ЗанимаемыхСтавок;
		Иначе
			ТекущаяСтрока = НайденныеСтроки[0]; 
			ТекущаяСтрока.ЗанимаемыхСтавокСтарое = Стр.ЗанимаемыхСтавок;
		КонецЕсли;

	КонецЦикла;	
	
	ЗначениеВРеквизитФормы(ТекущийОбъект,"Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборСотрудниковОрганизации.Форма.ФормаПодбора" Тогда
		
		ПолучитьРезультатПодбораИзХранилища(ВыбранноеЗначение.АдресРезультатаПодбораВХранилище);
		
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;

	Модифицированность = Истина;
		
КонецПроцедуры

//-АСТБ_Овсянников_---------------------------------------------------------------

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
    ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов