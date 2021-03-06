////////////////////////////////////////////////////////////////////////////////
// Подсистема "Запрет редактирования реквизитов объектов".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определить объекты метаданных, в модулях менеджеров которых ограничивается возможность редактирования реквизитов
// с помощью экспортной функции ПолучитьБлокируемыеРеквизитыОбъекта.
//
// Параметры:
//   Объекты - Соответствие - в качестве ключа указать полное имя объекта метаданных,
//                            подключенного к подсистеме "Запрет редактирования реквизитов объектов";
//                            В качестве значения - пустую строку.
//
// Пример: 
//   Объекты.Вставить(Метаданные.Документы.ЗаказПокупателя.ПолноеИмя(), "");
//
Процедура ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты) Экспорт
	
	//АсТБ_Alexey_********************************************************************
	Объекты.Вставить(Метаданные.Справочники.ДолжностиИПрофессии.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.МВЗ.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.Номенклатура.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.Подразделения.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.РабочиеМестаАСТБ.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.Сотрудники.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.ФизическиеЛица.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.ВозвратНоменклатурыПоставщику.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.ВыдачаСредствЗащитыСотруднику.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.ИнвентаризацияНоменклатуры.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.КадровоеПеремещение.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.ОприходованиеНоменклатуры.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.ОтсутствиеНаРабочемМесте.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.ПеремещениеНоменклатуры.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.ПоступлениеНоменклатуры.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.ПриемНаРаботу.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.СписаниеНоменклатуры.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.ТранспортнаяПоставка.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.Увольнение.ПолноеИмя(), "");
	//АсТБ_Alexey_********************************************************************
	
КонецПроцедуры

#КонецОбласти
