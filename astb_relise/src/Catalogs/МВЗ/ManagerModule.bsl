#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой ЗапретРедактированияРеквизитовОбъектов.

// Возвращает описание блокируемых реквизитов.
//
// Возвращаемое значение:
//     Массив - содержит строки в формате ИмяРеквизита[;ИмяЭлементаФормы,...]
//              где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы - имя элемента формы, связанного с
//              реквизитом.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
    Результат.Добавить("КодСинхронизации");
    Возврат Результат;
	
КонецФункции

#КонецЕсли