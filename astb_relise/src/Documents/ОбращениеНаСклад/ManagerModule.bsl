#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОбращениеНаСклад.Дата КАК Период,
	|	ОбращениеНаСклад.Организация КАК Организация,
	|	ОбращениеНаСклад.Склад КАК Склад,
	|	ОбращениеНаСклад.Сотрудник КАК Сотрудник,
	|	ОбращениеНаСклад.КатегорияОбращения КАК КатегорияОбращения,
	|	ОбращениеНаСклад.СодержаниеОбращения КАК СодержаниеОбращения,
	|	ОбращениеНаСклад.ДатаОтвета КАК ДатаОтвета,
	|	ОбращениеНаСклад.СтатусОбращения КАК СтатусОбращения,
	|	ОбращениеНаСклад.СодержаниеОтвета КАК СодержаниеОтвета
	|ИЗ
	|	Документ.ОбращениеНаСклад КАК ОбращениеНаСклад
	|ГДЕ
	|	ОбращениеНаСклад.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",ДокументСсылка);
	
	//по регистру "ИсторияОбращенийНаСклад"
	ТаблицыДляДвижений.Вставить("ТаблицаИсторияОбращенийНаСклад", Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ЗаполнитьТаблицуДокумента(ТекущийОбъект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	АлгоритмФормированияПотребности = ПроцедурыРаботыСНормамиСервер.ПолучитьАлгоритмФормированияПотребности(ТекущийОбъект.Организация);
	
	Если АлгоритмФормированияПотребности = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Выполнить("Алгоритм_" + АлгоритмФормированияПотребности + "_Сервер.ОбращениеНаСклад_ЗаполнитьТаблицуДокумента(ТекущийОбъект)");
	
КонецПроцедуры

#КонецЕсли