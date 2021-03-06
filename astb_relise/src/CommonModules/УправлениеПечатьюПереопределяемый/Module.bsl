////////////////////////////////////////////////////////////////////////////////
// Подсистема "Печать".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет таблицу возможных форматов для сохранения табличного документа.
// Вызывается из ОбщегоНазначения.НастройкиФорматовСохраненияТабличногоДокумента()
//
// Параметры:
//  ТаблицаФорматов - ТаблицаЗначений:
//                   *  ТипФайлаТабличногоДокумента - ТипФайлаТабличногоДокумента                 - значение в
//                                                                                                  платформе,
//                                                                                                  соответствующее
//                                                                                                  формату;
//                   *  Ссылка                      - ПеречислениеСсылка.ФорматыСохраненияОтчетов - ссылка на
//                                                                                                  метаданные, где
//                                                                                                  хранится
//                                                                                                  представление;
//                   *  Представление               - Строка -                                    - представление типа
//                                                             файла (заполняется из перечисления);
//                   *  Расширение                  - Строка -                                    - тип файла для
//                                                             операционной системы;
//                   *  Картинка                    - Картинка                                    - значок формата.
//
Процедура ПриЗаполненииНастроекФорматовСохраненияТабличногоДокумента(ТаблицаФорматов) Экспорт
	
КонецПроцедуры

// Переопределяет список команд печати, получаемый функцией УправлениеПечатью.КомандыПечатиФормы.
Процедура ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Дополнительные настройки списка команд печати.
//
// Параметры:
//  НастройкиСписка - Структура - модификаторы списка команд печати.
//   * МенеджерКомандПечати     - МенеджерОбъекта - менеджер объекта, в котором формируется список команд печати;
//   * АвтоматическоеЗаполнение - Булево - заполнять команды печати из объектов, входящих в состав журнала.
//                                         Значение по умолчанию: Истина.
//
Процедура ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка) Экспорт
	
КонецПроцедуры

// Определяет объекты, в которых есть процедура ДобавитьКомандыПечати().
//
// Параметры:
//  СписокОбъектов - Массив - список менеджеров объектов.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	//АсТБ_Alexey_********************************************************************
	СписокОбъектов.Добавить(Справочники.ВидыРемонтаСИЗ);
	СписокОбъектов.Добавить(Справочники.Сотрудники);
	СписокОбъектов.Добавить(Документы.ВозвратИзЧистки);
	СписокОбъектов.Добавить(Документы.ВозвратНоменклатурыПоставщику);
	СписокОбъектов.Добавить(Документы.ВозвратСредствЗащитыОтСотрудника);
	СписокОбъектов.Добавить(Документы.ВозвратСредствЗащитыСХранения);
	СписокОбъектов.Добавить(Документы.ВыдачаДежурныхСредствЗащиты);
	СписокОбъектов.Добавить(Документы.ВыдачаСредствЗащитыПоВедомости);
	СписокОбъектов.Добавить(Документы.ВыдачаСредствЗащитыСотруднику);
	СписокОбъектов.Добавить(Документы.ЗаказПоставщику);
	СписокОбъектов.Добавить(Документы.ЗаявкаНаВыдачу);
	СписокОбъектов.Добавить(Документы.ЗаявкаНаПроизвольнуюВыдачуСИЗ);
	СписокОбъектов.Добавить(Документы.ЗачетВыданныхСредствЗащиты);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияНоменклатуры);
	СписокОбъектов.Добавить(Документы.КомплектацияНоменклатуры);
	СписокОбъектов.Добавить(Документы.ОприходованиеНоменклатуры);
	СписокОбъектов.Добавить(Документы.НаправлениеНаМедицинскийОсмотр);
	СписокОбъектов.Добавить(Документы.ПередачаВЧистку);
	СписокОбъектов.Добавить(Документы.ПередачаСИЗвУтилизацию);
	СписокОбъектов.Добавить(Документы.ПеремещениеНоменклатуры);
	СписокОбъектов.Добавить(Документы.ПеремещениеСредствЗащитыНаХранении);
	СписокОбъектов.Добавить(Документы.ПереходПраваСобственности);
	СписокОбъектов.Добавить(Документы.ПоступлениеНоменклатуры);
	СписокОбъектов.Добавить(Документы.ПриемСредствЗащитыНаХранение);
	//АсТБ_Alexey_72252_********************************************************************
	СписокОбъектов.Добавить(Документы.ВыполненныеРаботыПоРемонту);
	СписокОбъектов.Добавить(Документы.РемонтСредствЗащиты);
	//АсТБ_Alexey_72252_********************************************************************
	СписокОбъектов.Добавить(Документы.СписаниеНоменклатуры);
	СписокОбъектов.Добавить(Документы.СписаниеСредствЗащитыСотрудника);
	СписокОбъектов.Добавить(Документы.УстановкаШтрихкодовНоменклатуры);
	//АсТБ_Alexey_********************************************************************
	
КонецПроцедуры

// Вызывается после завершения вызова процедуры Печать менеджера печати объекта, имеет те же параметры.
// 
// Параметры:
//  МассивОбъектов - Массив - список объектов, для которых была выполнена процедура Печать;
//  ПараметрыПечати - Структура - произвольные параметры, переданные при вызове команды печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - содержит табличные документы и дополнительную информацию;
//  ОбъектыПечати - СписокЗначений - соответствие между объектами и именами областей в табличных документах, где
//                                   значение - Объект, представление - имя области с объектом в табличных документах;
//  ПараметрыВывода - Структура - параметры, связанные с выводом табличных документов:
//   * ПараметрыОтправки - Структура - информация для заполнения письма при отправке печатной формы по электронной почте.
//                                     Содержит следующие поля (описание см. в общем модуле конфигурации
//                                     РаботаСПочтовымиСообщениямиКлиент в процедуре СоздатьНовоеПисьмо):
//    ** Получатель;
//    ** Тема,
//    ** Текст.
Процедура ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	
КонецПроцедуры

// Переопределяет параметры отправки печатных форм при подготовке письма.
// 
// Параметры:
//
//  ПараметрыОтправки
//    * Получатель - Массив
//    * Тема - Строка
//    * Текст - Строка
//    * Вложения - Структура:
//      ** АдресВоВременномХранилище - Строка.
//      ** Представление - Строка - имя файла.
//  ОбъектыПечати - Массив - параметр МассивСсылок в вызове процедуры Печать.
//  ПараметрыВывода - Структура - параметр ПараметрыВывода в вызове процедуры Печать.
//  ПечатныеФормы - ТаблицаЗначений - коллекция табличных документов:
//    * Название - Строка - название печатной формы;
//    * ТабличныйДокумент - ТабличныйДокумент - печатая форма.
Процедура ПередОтправкойПоПочте(ПараметрыОтправки, ПараметрыВывода, ОбъектыПечати, ПечатныеФормы) Экспорт
	
КонецПроцедуры

#КонецОбласти
