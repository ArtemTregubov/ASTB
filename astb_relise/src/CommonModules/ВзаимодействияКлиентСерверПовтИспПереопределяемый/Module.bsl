
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Взаимодействия"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// В данной функции при необходимости формируется массив строковых представлений предметов взаимодействий.
// Используется, если в конфигурации определен хотя бы один предмет взаимодействий.
//
// Возвращаемое значение:
//   Булево   - массив строковых представлений возможных предметов взаимодействий.
//
Функция МассивТиповПредметов() Экспорт
	
	МассивТиповПредметов = Новый Массив;
	
	

	Возврат МассивТиповПредметов;
	
КонецФункции

// Дополняет описания возможных типов контактов.
// Используется, если в конфигурации определен хотя бы один тип контактов взаимодействий,
// помимо справочника Пользователи.
//
// Возвращаемые :
//   Массив  - массив структур, в котором описываются возможные типы контактов.
//              Каждая структура содержит описание одного типа контактов.   
//              Описание полей структуры см. в комментарии к функции.
//              ДобавитьЭлементМассиваОписанияВозможныхТиповКонтактов общего модуля.
//              ВзаимодействияКлиентСервер.
//
Процедура ДополнитьМассивОписанияВозможныхКонтактов(МассивВозможныеКонтакты) Экспорт

	//АсТБ_Alexey_********************************************************************
	
	СтруктураОписания = Новый Структура;
	СтруктураОписания.Вставить("Тип",                               Тип("СправочникСсылка.ФизическиеЛица"));
	СтруктураОписания.Вставить("ВозможностьИнтерактивногоСоздания", Ложь);
	СтруктураОписания.Вставить("Имя",                               "ФизическиеЛица");
	СтруктураОписания.Вставить("Представление",                     "Физические лица");
	СтруктураОписания.Вставить("Иерархический",                     Ложь);
	СтруктураОписания.Вставить("ЕстьВладелец",                      Ложь);
	СтруктураОписания.Вставить("ИмяВладельца",                      "");
	СтруктураОписания.Вставить("ИскатьПоДомену",                    Ложь);
	СтруктураОписания.Вставить("Связь",                             "");
	СтруктураОписания.Вставить("ИмяРеквизитаПредставлениеКонтакта", "Наименование");

	
	МассивВозможныеКонтакты.Добавить(СтруктураОписания);

	//АсТБ_Alexey_********************************************************************
	
КонецПроцедуры

#КонецОбласти
