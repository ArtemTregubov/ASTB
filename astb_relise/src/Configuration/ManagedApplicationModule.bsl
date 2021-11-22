
// СтандартныеПодсистемы

#Область ОписаниеПеременных

// Хранилище глобальных переменных.
//
// ПараметрыПриложения - Соответствие - хранилище переменных, где:
//   * Ключ - Строка - имя переменной в формате "ИмяБиблиотеки.ИмяПеременной";
//   * Значение - Произвольный - значение переменной.
//
// Инициализация (на примере СообщенияДляЖурналаРегистрации):
//   ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
//   Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
//     ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
//   КонецЕсли;
//  
// Использование (на примере СообщенияДляЖурналаРегистрации):
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"].Добавить(...);
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"] = ...;
Перем ПараметрыПриложения Экспорт;

//АсТБ_Alexey_********************************************************************
// ПодключаемоеОборудование
Перем глПодключаемоеОборудование Экспорт; // для кэширования на клиенте
Перем глПодключаемоеОборудованиеСобытиеОбработано Экспорт; // для предотвращения повторной обработки события
Перем глДоступныеТипыОборудования Экспорт;
// Конец ПодключаемоеОборудование
//АсТБ_Alexey_********************************************************************

#КонецОбласти

// Конец СтандартныеПодсистемы


#Область ОбработчикиСобытий

Процедура ПередНачаломРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
	//АсТБ_Alexey_********************************************************************
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПередНачаломРаботыСистемы();
	// Конец ПодключаемоеОборудование
	//АсТБ_Alexey_********************************************************************
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
	//АсТБ_Alexey_********************************************************************
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПриНачалеРаботыСистемы();
	// Конец ПодключаемоеОборудование
	//АсТБ_Alexey_********************************************************************
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения);
	// Конец СтандартныеПодсистемы
	
	//АсТБ_Alexey_********************************************************************
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПередЗавершениемРаботыСистемы();
	// Конец ПодключаемоеОборудование
	//АсТБ_Alexey_********************************************************************
	
КонецПроцедуры

//АсТБ_Alexey_********************************************************************

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)

	// ПодключаемоеОборудование
	// Подготовить данные
	
	ОписаниеСобытия = Новый Структура();
	ОписаниеОшибки  = "";
	
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие",  Событие);
	ОписаниеСобытия.Вставить("Данные",   Данные);
	
	// Передать на обработку данные.
	Результат = МенеджерОборудованияКлиент.ОбработатьСобытиеОтУстройства(ОписаниеСобытия, ОписаниеОшибки);
	Если Не Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При обработке внешнего события от устройства произошла ошибка.'") + Символы.ПС + ОписаниеОшибки);
	Иначе
		Если Событие = "ДанныеКарты" И ЗначениеЗаполнено(Данные) Тогда
			ПроцедурыРаботыСНормамиКлиент.ОткрытьКарточкуСотрудникаПоМагнитнойКарте(Данные);
		КонецЕсли;	
	КонецЕсли;
	// Конец ПодключаемоеОборудование

КонецПроцедуры

//АсТБ_Alexey_********************************************************************

#КонецОбласти