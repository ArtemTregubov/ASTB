
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект,НОВЫЙ Структура("ИмяЭлементаДляРазмещения","ГруппаДополнительныеРеквизиты"));
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	// ПодключаемоеОборудование
	ПроцедурыРаботыСНормамиСервер.НастроитьПодключаемоеОборудование(ЭтаФорма);
	// Конец ПодключаемоеОборудование
	
	ЭтаФорма.Элементы.МОЛ.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьМассивМОЛСклада(Объект.Склад,Объект.Организация));
	
	УстановитьВидимостьЭлементовФормы();
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы()
	
	//подменю "Заполнить"
	Если Элементы.Товары.КоманднаяПанель.ПодчиненныеЭлементы.ТоварыЗагрузитьДанныеИзТСД.Видимость Тогда
		Элементы.Товары.КоманднаяПанель.ПодчиненныеЭлементы.ТоварыЗагрузитьДанныеИзТСД.Видимость = НЕ ЗначениеЗаполнено(Объект.ДокументОснование);
	КонецЕсли;	
	Элементы.Товары.КоманднаяПанель.ПодчиненныеЭлементы.ТоварыГруппаЗаполнить.ПодчиненныеЭлементы.ТоварыЗаполнитьПоОснованию.Видимость = ЗначениеЗаполнено(Объект.ДокументОснование);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовФормы()
	
	Элементы.Сотрудник.Доступность 					= НЕ ЗначениеЗаполнено(Объект.ДокументОснование);	
	Элементы.Организация.Доступность 				= Не ЗначениеЗаполнено(Объект.ДокументОснование);
	
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
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			ОбработатьШтрихкоды(ПроцедурыРаботыСНормамиКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
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
			Элемент.ТекущиеДанные.Цена = ПолучитьЦенуСервер(Элемент.ТекущиеДанные.Номенклатура);
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

&НаСервере
Функция ПолучитьЦенуСервер(Номенклатура)
	
	Возврат ЦенообразованиеСерверПереопределяемый.ПолучитьЦену(Номенклатура,Объект.Организация,Объект.Дата);
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПоСотруднику(Команда)
	
	ЗаполнитьПоСотрудникуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоСотрудникуНаСервере()

	ТекущийОбъект = РеквизитФормыВЗначение("Объект");	
	
	Документы.ВозвратСредствЗащитыСХранения.ЗаполнитьДокумент(ТекущийОбъект);
	
	ЗначениеВРеквизитФормы(ТекущийОбъект,"Объект");
	
	Модифицированность = Истина;
	
КонецПроцедуры

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
    ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	//АСТБ_ALEXEY_70409**************************************************************
	//Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация);
	Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация,Объект.СоздательДокумента);
	//АСТБ_ALEXEY_70409**************************************************************
	Элементы.МОЛ.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьМассивМОЛСклада(Объект.Склад,Объект.Организация));
	
	ЭтаФорма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
	Объект.Товары.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	//АСТБ_ALEXEY_70409**************************************************************
	//Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация);
	Объект.МОЛ = ПроцедурыРаботыСНормамиСервер.ПолучитьМОЛСклада(Объект.Склад,Объект.Организация,Объект.СоздательДокумента);
	//АСТБ_ALEXEY_70409**************************************************************
	Элементы.МОЛ.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьМассивМОЛСклада(Объект.Склад,Объект.Организация));
	Объект.ТочкаХранения = ПредопределенноеЗначение("Справочник.ТочкиХранения.ПустаяСсылка");
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	Объект.Товары.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;

    Объект.Товары.Очистить();
	
	Объект.Сотрудник = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоСотрудникам(Команда)
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна",  РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("РежимВыбора",        Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормыВыбора.Вставить("Отбор",              Новый Структура("Владелец", Объект.Организация));
	
	ОткрытьФорму("Справочник.Сотрудники.ФормаВыбора",ПараметрыФормыВыбора,ЭтаФорма,УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПодразделениям(Команда)
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна",  РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("РежимВыбора",        Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормыВыбора.Вставить("Отбор",              Новый Структура("Владелец", Объект.Организация));
	
	ОткрытьФорму("Справочник.Подразделения.ФормаВыбора",ПараметрыФормыВыбора,ЭтаФорма,УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоСкладамВыдачи(Команда)
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна",  РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("РежимВыбора",        Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	
	ОткрытьФорму("Справочник.Склады.ФормаВыбора",ПараметрыФормыВыбора,ЭтаФорма,УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	Перем ТаблицаЗагрузкиИзТСД;
	
	МенеджерОборудованияКлиент.ЗагрузитьДанныеИзТСД(УникальныйИдентификатор, ТаблицаЗагрузкиИзТСД);
	
	ОбработатьШтрихкоды(ТаблицаЗагрузкиИзТСД);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	ОбработатьШтрихкодыСервер(Новый Структура("Штрихкоды",ДанныеШтрихкодов));
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкодыСервер(СтруктураПараметров)
	
	ПроцедурыРаботыСНормамиСервер.ОбработатьШтрихкоды(ЭтаФорма,Объект,СтруктураПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.Сотрудники.Форма.ФормаВыбора" Тогда
		
		Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			
			ЗаполнитьПоСотрудникамНаСервере(ВыбранноеЗначение);
			
		КонецЕсли;
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.Подразделения.Форма.ФормаВыбора" Тогда
		
		Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			
			ЗаполнитьПоПодразделениямНаСервере(ВыбранноеЗначение);
			
		КонецЕсли;
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.Склады.Форма.ФормаВыбора" Тогда
		
		Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			
			ЗаполнитьПоСкладамНаСервере(ВыбранноеЗначение);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;

	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоПодразделениямНаСервере(ВыбранноеЗначение)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗанятыеРабочиеМестаОстатки.Сотрудник КАК Сотрудник
	|ИЗ
	|	РегистрНакопления.ЗанятыеРабочиеМеста.Остатки(
	|			&ДатаАнализа,
	|			Организация = &Организация
	|				И Подразделение В (&МассивПодразделений)) КАК ЗанятыеРабочиеМестаОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗанятыеРабочиеМестаОстатки.Сотрудник.Наименование";
	
	Запрос.УстановитьПараметр("ДатаАнализа",		ПроцедурыРаботыСНормамиСервер.ПолучитьГраницуАнализаПоДокументу(Объект.Ссылка));
	Запрос.УстановитьПараметр("Организация",		Объект.Организация);
	Запрос.УстановитьПараметр("МассивПодразделений",ВыбранноеЗначение);
	
	МассивСотрудников = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Сотрудник");
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	
	Документы.ВозвратСредствЗащитыСХранения.ЗаполнитьДокумент(ТекущийОбъект,МассивСотрудников);
	
	ЗначениеВРеквизитФормы(ТекущийОбъект,"Объект");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоСотрудникамНаСервере(ВыбранноеЗначение)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	
	Документы.ВозвратСредствЗащитыСХранения.ЗаполнитьДокумент(ТекущийОбъект,ВыбранноеЗначение);
	
	ЗначениеВРеквизитФормы(ТекущийОбъект,"Объект");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоСкладамНаСервере(ВыбранноеЗначение)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СкладыВыдачиСредствЗащиты.Получатель КАК Получатель
	|ПОМЕСТИТЬ ВТ_Получатели
	|ИЗ
	|	РегистрСведений.СкладыВыдачиСредствЗащиты КАК СкладыВыдачиСредствЗащиты
	|ГДЕ
	|	СкладыВыдачиСредствЗащиты.Организация = &Организация
	|	И СкладыВыдачиСредствЗащиты.Склад В(&МассивСкладов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗанятыеРабочиеМестаОстатки.Сотрудник КАК Сотрудник,
	|	ЗанятыеРабочиеМестаОстатки.Подразделение КАК Подразделение
	|ПОМЕСТИТЬ ВТ_ЗРМ
	|ИЗ
	|	РегистрНакопления.ЗанятыеРабочиеМеста.Остатки(&ДатаАнализа, Организация = &Организация) КАК ЗанятыеРабочиеМестаОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ВТ_ЗРМ.Сотрудник ЕСТЬ NULL
	|			ТОГДА ВТ_ЗРМ1.Сотрудник
	|		ИНАЧЕ ВТ_ЗРМ.Сотрудник
	|	КОНЕЦ КАК Сотрудник
	|ПОМЕСТИТЬ ВТ_Результат
	|ИЗ
	|	ВТ_Получатели КАК ВТ_Получатели
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ЗРМ КАК ВТ_ЗРМ
	|		ПО ВТ_Получатели.Получатель = ВТ_ЗРМ.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ЗРМ КАК ВТ_ЗРМ1
	|		ПО ВТ_Получатели.Получатель = ВТ_ЗРМ1.Подразделение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_Результат.Сотрудник КАК Сотрудник
	|ИЗ
	|	ВТ_Результат КАК ВТ_Результат
	|ГДЕ
	|	НЕ ВТ_Результат.Сотрудник ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("ДатаАнализа",		ПроцедурыРаботыСНормамиСервер.ПолучитьГраницуАнализаПоДокументу(Объект.Ссылка));
	Запрос.УстановитьПараметр("Организация",		Объект.Организация);
	Запрос.УстановитьПараметр("МассивСкладов",		ВыбранноеЗначение);
	
	МассивСотрудников = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Сотрудник");
	
	Документы.ВозвратСредствЗащитыСХранения.ЗаполнитьДокумент(ТекущийОбъект,МассивСотрудников);
	
	ЗначениеВРеквизитФормы(ТекущийОбъект,"Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОснованию(Команда)
	
	ЗаполнитьПоОснованиюНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюНаСервере()
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");	
	
	Документы.ВозвратСредствЗащитыСХранения.ЗаполнитьДокументПоОснованию(ТекущийОбъект,ТекущийОбъект.ДокументОснование);
	
	ЗначениеВРеквизитФормы(ТекущийОбъект,"Объект");
	
	УстановитьВидимостьЭлементовФормы();
	УстановитьДоступностьЭлементовФормы();
	
	Модифицированность = Истина;
	
КонецПроцедуры	

&НаКлиенте
Процедура ТочкаХраненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Справочник.ТочкиХранения.ФормаВыбора", Новый Структура("СписокТочекХранения", ПроцедурыРаботыСНормамиСервер.ПолучитьСписокТочекХраненияПоСкладу(Объект.Склад)),Элемент);
	
КонецПроцедуры
