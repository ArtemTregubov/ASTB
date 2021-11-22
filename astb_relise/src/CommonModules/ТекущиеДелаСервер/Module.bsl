////////////////////////////////////////////////////////////////////////////////
// Подсистема "Текущие дела".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает массив подсистем командного интерфейса, в которые включен переданный
// объект метаданных.
//
// Параметры:
//  ИмяОбъектаМетаданных - Строка - полное имя объекта метаданных.
//
// Возвращаемое значение: 
//  Массив - массив подсистем командного интерфейса программы.
//
Функция РазделыДляОбъекта(ИмяОбъектаМетаданных) Экспорт
	ПринадлежностьОбъектов = ТекущиеДелаСлужебныйПовтИсп.ПринадлежностьОбъектовРазделамКомандногоИнтерфейса();
	ПодсистемыКомандногоИнтерфейса = ПринадлежностьОбъектов[ИмяОбъектаМетаданных];
	Если ПодсистемыКомандногоИнтерфейса = Неопределено Тогда
		ПодсистемыКомандногоИнтерфейса = Новый Массив;
		ПодсистемыКомандногоИнтерфейса.Добавить(Обработки.ТекущиеДела);
	КонецЕсли;
	
	Возврат ПодсистемыКомандногоИнтерфейса;
КонецФункции

// Определяет, нужно ли выводить дело в списке дел пользователя.
//
// Параметры:
//  ИдентификаторДела - Строка - идентификатор дела, которое надо искать в списке отключенных.
//
Функция ДелоОтключено(ИдентификаторДела) Экспорт
	ОтключаемыеДела = Новый Массив;
	ТекущиеДелаПереопределяемый.ПриОтключенииТекущихДел(ОтключаемыеДела);
	
	Возврат (ОтключаемыеДела.Найти(ИдентификаторДела) <> Неопределено)
	
КонецФункции

// Возвращает структуру общих значений, используемых для расчета текущих дел.
//
// Возвращаемое значение:
//  Структура с ключами:
//    * Пользователь - СправочникСсылка.Пользователи, СправочникСсылка.ВнешниеПользователи - текущий пользователь.
//    * ЭтоПолноправныйПользователь - Булево - Истина, если пользователь полноправный.
//    * ТекущаяДата - Дата - текущая дата сеанса.
//    * ПустаяДата  - Дата - пустая дата.
//
Функция ОбщиеПараметрыЗапросов() Экспорт
	Возврат ТекущиеДелаСлужебный.ОбщиеПараметрыЗапросов();
КонецФункции

// Устанавливает общие параметры запросов для расчета текущих дел.
//
// Параметры:
//  Запрос - выполняемый запрос.
//  ОбщиеПараметрыЗапросов - Структура - общие значения для расчета показателей.
//
Процедура УстановитьПараметрыЗапросов(Запрос, ОбщиеПараметрыЗапросов) Экспорт
	ТекущиеДелаСлужебный.УстановитьОбщиеПараметрыЗапросов(Запрос, ОбщиеПараметрыЗапросов);
КонецПроцедуры

// Получает числовые значения дел из переданного запроса.
//
// Запрос с данными должен содержать только одну строку с произвольным количеством полей.
// Значения этих полей должны являться значениями соответствующих показателей.
//
// Пример простейшего запроса:
//   ВЫБРАТЬ
//      Количество(*) КАК <Имя предопределенного элемента - показателя количества документов>.
//   ИЗ
//      Документ.<Имя документа>.
//
// Параметры:
//  Запрос - выполняемый запрос.
//  ОбщиеПараметрыЗапросов - Структура - общие значения для расчета текущих дел.
//
// Возвращаемое значение:
//  Структура со свойствами:
//     * Ключ     - Строка - имя показателя текущих дел.
//     * Значение - Число - числовое значение показателя.
//
Функция ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов = Неопределено) Экспорт
	Возврат ТекущиеДелаСлужебный.ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов);
КонецФункции

#КонецОбласти

