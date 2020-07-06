import time
import pandas as pd
import numpy as np

CITY_DATA = { 'chicago': 'chicago.csv',
              'new york city': 'new_york_city.csv',
              'washington': 'washington.csv' }



def get_filters():
    """
    Asks user to specify a city, month, and day to analyze.

    Returns:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    """
    print('Hello! Let\'s explore some US bikeshare data!')
    # TO DO: get user input for city (chicago, new york city, washington). 
    #HINT: Use a while loop to handle invalid inputs
     
    city  = str(input("Would you like to see data for Chicago, New York, or Washington? :")).lower().strip()
        
    while city not in ['chicago','new york','washington']:
        print("You gave wrong input. Please choose from these three cities ")
        city = str(input("Would you like to see data for Chicago, New York, or Washington? :")).lower().strip()
    
    if city == 'new york':
        city += ' city'
        
    #print(city)
    
    choose = str(input("Would you like to filter the data by month, day, or not at all? Type None if you do not need to filter the data:  ")).lower().strip()
    while choose not in ['month','day','none']:
        print("You gave wrong input. Please type the correct input")
        choose = str(input("Would you like to filter the data by month, day, or not at all? Type None if you do not need to filter the data: ")).lower().strip()
    #print(choose)
    
    if choose == 'month':
        # TO DO: get user input for month (all, january, february, ... , june)
        month = str(input("Which month - January, February, March, April, May, or June? :" )).lower().strip()
        while month not in ['january','february','march','april','may','june']:
            print("You gave wrong input. Please type the correct input")
            month = str(input("Which month - January, February, March, April, May, or June? : " )).lower().strip()
        #print(month)
        day = 'all'
    
    elif choose == 'day':
        # TO DO: get user input for day of week (all, monday, tuesday, ... sunday)
        day = str(input("Which day - Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, or Sunday? :")).lower().strip()
        while day not in ['monday','tuesday','wednesday','thursday','friday','saturday','sunday']:
             print("You gave wrong input. Please type the correct input")
             day = str(input("Which day - Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, or Sunday? :")).lower().strip()
        #print(day)
        month = 'all'
    
    else:
        month = 'all'
        day = 'all'

    print('-'*40)
    return city, month, day


def load_data(city, month, day):
    """
    Loads data for the specified city and filters by month and day if applicable.

    Args:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    Returns:
        df - Pandas DataFrame containing city data filtered by month and day
    """
    # load data file into a dataframe
    df = pd.read_csv(CITY_DATA[city])

    # convert the Start Time column to datetime
    df['Start Time'] = pd.to_datetime(df['Start Time'])
    df['End Time'] = pd.to_datetime(df['End Time'])

    # extract month and day of week from Start Time to create new columns
    df['month'] = df['Start Time'].dt.month
    df['day_of_week'] = df['Start Time'].dt.weekday_name

    # filter by month if applicable
    if month != 'all':
        # use the index of the months list to get the corresponding int
        months = ['january', 'february', 'march', 'april', 'may', 'june']
        month = months.index(month) + 1
       

        # filter by month to create the new dataframe
        df = df[df['month'] == month]

    # filter by day of week if applicable
    if day != 'all':
        # filter by day of week to create the new dataframe
        df = df[df['day_of_week'] == day.title()]

    return df


def time_stats(df):
    """Displays statistics on the most frequent times of travel."""

    print('\nCalculating The Most Frequent Times of Travel...\n')
    start_time = time.time()

    # TO DO: display the most common month
    months = ['january', 'february', 'march', 'april', 'may', 'june']
    month =  months[(df['month'].mode()[0])-1]
    print("The most commont month is {}".format(month.title()))


    # TO DO: display the most common day of week
    print("The most common day of week is {}".format(df['day_of_week'].mode()[0]))

    # TO DO: display the most common start hour
    print("The most common start hour is {}".format(df['Start Time'].mode()[0]))

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def station_stats(df):
    """Displays statistics on the most popular stations and trip."""

    print('\nCalculating The Most Popular Stations and Trip...\n')
    start_time = time.time()

    # TO DO: display most commonly used start station
    print("The most commonly used start station is {}".format(df['Start Station'].mode()[0]))

    # TO DO: display most commonly used end station
    print("The most commonly used end station is {}".format(df['End Station'].mode()[0]))

    # TO DO: display most frequent combination of start station and end station trip
    common_trip = (df['Start Station']+ '-' +df['End Station']).mode()[0]
    start_station = common_trip.split('-')[0]
    end_station = common_trip.split('-')[1]
    
    print("The most frequent combination of start station and end station trip : \n")
    print("Start Station : {} \nEnd Station   : {}".format(start_station, end_station))

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def trip_duration_stats(df):
    """Displays statistics on the total and average trip duration."""

    print('\nCalculating Trip Duration...\n')
    start_time = time.time()

    # TO DO: display total travel time
   
    travel_time = (df['End Time'] - df['Start Time'])
    print("Total Travel time : {}".format(travel_time.sum()))

    # TO DO: display mean travel time
    print("Mean Travel time : {} seconds".format((travel_time.mean().total_seconds())/60))

    print("\nThis took %s minutes." % (time.time() - start_time))
    print('-'*40)


def user_stats(df):
    """Displays statistics on bikeshare users."""

    print('\nCalculating User Stats...\n')
    start_time = time.time()

    # TO DO: Display counts of user types
   
    count_user = df['User Type'].value_counts().tolist()
    user_list = df['User Type'].value_counts().index.tolist()
    print("Count of user types")
    index = 0
    for user in user_list:
        print("{} : {}".format(user,count_user[index]))
        index += 1
   

    # TO DO: Display counts of gender
    if 'Gender' in df:
        count_gender = df['Gender'].value_counts().tolist()
        gender_list = df['Gender'].value_counts().index.tolist()
        print("\nCount of Gender")
        index = 0
        for gender in gender_list:
            print("{} : {}".format(gender,count_gender[index]))
            index += 1

    # TO DO: Display earliest, most recent, and most common year of birth
    if 'Birth Year' in df:
        earliest_birth_year = df['Birth Year'].min()
        most_recent_birth = df['Birth Year'].max()
        common_birth = df['Birth Year'].mode()
    
        print("\nEarliest birth year : {}".format(int(earliest_birth_year)))
        print("\nRecent birth year : {}".format(int(most_recent_birth)))
        print("\nCommon birth year : {}".format(int(common_birth)))

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def main():
    while True:        
        city, month, day = get_filters()
        df = load_data(city, month, day)
        #print(df)

        time_stats(df)
        station_stats(df)
        trip_duration_stats(df)
        user_stats(df)

        restart = input('\nWould you like to restart? Enter yes or no.\n')
        if restart.lower() != 'yes':
            break
         


if __name__ == "__main__":
	main()
