# Everything you need to mess with the dataset

import pandas as pd
import requests
import sqlalchemy as sq
import streamlit as st


def name_loader():
    """
    Loads table of common names
    """
    engine = sq.create_engine("sqlite:///data/names.db")
    cnx = engine.connect()
    return pd.read_sql("names", cnx)


class getCurrency:
    def __init__(self):
        """
        Gets the latest currency->USD conversion rates from ratesapi.io
        """
        import datetime as dt

        if dt.datetime.now().isocalendar()[2] % 2 == 0:
            # if day of the week is even (TRSat), call currency api
            self.new_rates()
            self.rate_ctry_merge()

        self.get_df()

    def new_rates(self):
        """
        Scrapes and returns latest currency info
        """
        url = "http://api.exchangeratesapi.io/v1/latest"
        params = {
            "access_key": "39bb68026251e7001df58311ef680d43",
            "symbols": "USD,AUD,CAD,PLN,MXN",
            "format": 1,
        }

        response = requests.get(url, params=params)
        rates = response.json()
        print(rates)

        rates_df = pd.DataFrame(rates["rates"].items(), columns=["currency", "rate"])
        print(rates_df)
        self.rates_df = rates_df

    def rate_ctry_merge(self):
        """
        Merges, formats, and saves to db the country info with newly scraped currency rates
        """
        import pandas as pd
        import sqlalchemy as sq

        engine = sq.create_engine("sqlite:///data/currency.db")
        cnx = engine.connect()
        self.country_df = pd.read_sql("country_currency", cnx)
        meta = sq.MetaData()
        meta.reflect(bind=engine)

        df = self.rates_df
        df = df.merge(self.country_df, left_on="currency", right_on="code")
        df = df.drop_duplicates(["currency_x", "currency_y", "code"]).reset_index(
            drop=True
        )
        df = df.rename({"currency_y": "currency"}, axis=1)
        df = df.drop("currency_x", axis=1)
        # rename countries to more well-known
        df = df.replace(
            {
                "American Samoa": "United States",
                "Bouvet Island": "Norway",
                "Cook Islands": "New Zealand",
                "Guernsey": "United Kingdom",
                "Korea, Republic of": "South Korea",
                "Liechtenstein": "Switzerland",
                "Russian Federation": "Russia",
                "Åland Islands": "European Union",
            }
        )
        import datetime as dt

        df["date_updated"] = dt.datetime.now().date()
        df.to_sql("currency_rates", cnx, if_exists="replace", index=False)

    def get_df(self):
        """
        Returns saved currency info from db
        """
        import pandas as pd
        import sqlalchemy as sq

        engine = sq.create_engine("sqlite:///data/currency.db")
        cnx = engine.connect()

        self.df = pd.read_sql("currency_rates", cnx, parse_dates="date_updated")

    def scrape_ctr():
        """
        Saved for posterity. Scrapes website for country currency info
        """
        url = "http://www.exchange-rate.com/currency-list.html"
        tables = pd.read_html(url)  # scrapes table on page
        country_currency = tables[0]
        country_currency.columns = ["country", "currency", "code", "comment"]
        country_currency = country_currency.drop(0).reset_index(drop=True)
        country_currency = country_currency.drop("comment", axis=1)
        return country_currency
