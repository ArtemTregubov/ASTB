#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УстановкаМВЗПодразделенийМВЗПодразделений.Ссылка.Дата КАК Период,
	|	УстановкаМВЗПодразделенийМВЗПодразделений.Подразделение,
	|	УстановкаМВЗПодразделенийМВЗПодразделений.МВЗ,
	|	УстановкаМВЗПодразделенийМВЗПодразделений.Использовать
	|ИЗ
	|	Документ.УстановкаМВЗПодразделений.МВЗПодразделений КАК УстановкаМВЗПодразделенийМВЗПодразделений
	|ГДЕ
	|	УстановкаМВЗПодразделенийМВЗПодразделений.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",ДокументСсылка);
	
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	
	//по регистру "МВЗ подразделений"
	ТаблицыДляДвижений.Вставить("ТаблицаМВЗПодразделений", Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ЗаполнитьТабличнуюЧасть(ТекущийОбъект) Экспорт	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МВЗПодразделенийСрезПоследних.Подразделение,
	|	МВЗПодразделенийСрезПоследних.МВЗ,
	|	МВЗПодразделенийСрезПоследних.Использовать
	|ПОМЕСТИТЬ ВТ_МВЗПодразделений
	|ИЗ
	|	РегистрСведений.МВЗПодразделений.СрезПоследних(&Период, ) КАК МВЗПодразделенийСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Подразделения.Ссылка
	|ПОМЕСТИТЬ ВТ_Подразделения
	|ИЗ
	|	Справочник.Подразделения КАК Подразделения
	|ГДЕ
	|	Подразделения.Владелец = &Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Подразделения.Ссылка КАК Подразделение,
	|	ЕСТЬNULL(ВТ_МВЗПодразделений.МВЗ, ЗНАЧЕНИЕ(Справочник.МВЗ.ПустаяСсылка)) КАК МВЗ,
	|	ВЫБОР
	|		КОГДА ВТ_МВЗПодразделений.МВЗ ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ВТ_МВЗПодразделений.Использовать
	|	КОНЕЦ КАК Использовать
	|ИЗ
	|	ВТ_Подразделения КАК ВТ_Подразделения
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_МВЗПодразделений КАК ВТ_МВЗПодразделений
	|		ПО ВТ_Подразделения.Ссылка = ВТ_МВЗПодразделений.Подразделение";
	
	Запрос.УстановитьПараметр("Период",		ПроцедурыРаботыСНормамиСервер.ПолучитьГраницуАнализаПоДокументу(ТекущийОбъект.Ссылка));
	Запрос.УстановитьПараметр("Владелец",	ТекущийОбъект.Организация);
	
	ТекущийОбъект.МВЗПодразделений.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ЗаполнитьПоВсемПодразделениям(ТекущийОбъект,ВыбранноеМВЗ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Подразделения.Ссылка КАК Подразделение,
	|	&МВЗ КАК МВЗ,
	|	ИСТИНА КАК Использовать
	|ИЗ
	|	Справочник.Подразделения КАК Подразделения
	|ГДЕ
	|	Подразделения.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец",	ТекущийОбъект.Организация);
	Запрос.УстановитьПараметр("МВЗ",		ВыбранноеМВЗ);
	
	ТекущийОбъект.МВЗПодразделений.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецЕсли